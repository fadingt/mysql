SELECT
		base.`no`, base.`name`, base.type,chargeperson, jianliren,
		base.gfamt,
		realfee.sjfy, fy.fy1 manualfee_spxs, fy.fy2 manualfee_other, (fy1+fy2) cgcb,
		base.gramt,
		cb1.gz standardcost, cb1.gzdiff, cb1.jj standardcost13, cb3.sjgz sjcb,
		unit.calcdept calcdeptname, unit.linename, unit.remark4 deptname
FROM
(
		SELECT
				`id`,	 `no`, `name`, chargeperson, jianliren, `unitid`,
				CONCAT(project.projecttypename,'-',project.businesstypename) `type`,
				gfamt,	gramt
		FROM
		(
				SELECT
					projectid `id`,
					projectno `no`,
					projectname `name`,
					deptid `unitid`,
					getusername(definer) jianliren, -- 立项人
					getusername(pd) chargeperson, -- 负责人?
					translatedict ('IDFS000070', projstatus) projstatusname,
					IFNULL(translatedict ('IDFS000091', projecttype),'') projecttypename,
					IFNULL(translatedict ('IDFS000092', businesstype),'') businesstypename,
					(fee+yjcb_cg) gfamt,-- 预计费用(实际费用+采购成本)
					(cost) gramt-- 预计成本
				from t_report_projectinfoinout
				where nowyear = 2018
		) project

		union all

		SELECT
			budgetid `id`, budgetno `no`, budgetname `name`,chargeperson, jianliren, unitid, type, gfamt, gramt
		from 
		(
			select 
				tf.budgetid,	'管理预算' as type,	0 as typevalue, ifnull(budgetno,'无编号') budgetno,	budgetname,
				departmentid unitid,	
				getusername(chargeperson) chargeperson, jianliren, 
				gfamt,gramt,	tf.year  
			from  
				(select tt.budgetid,budgetno,budgetname,departmentname as deptname, chargeperson,getusername(registerid) jianliren,budgetamount gfamt,tt.infoex2 gramt,departmentid,left(createtime,4) year  from  t_budget_deptannualbudget t
			LEFT JOIN  t_budget_deptlevelcost tt on t.budgetid=tt.budgetid 
			) tf  

			UNION ALL   -- ==================================================================================

			SELECT
				cbbusinessid,'销售预算' type, 3 as typevalue, businessno,businessname,
				deptid unitid, cbprincipalname, cbapplyusername,
				ysze gfamt,-- 预算费用总额
				salecost,-- 预算人工总额
				cb.cbyear
			FROM
			(
					SELECT 
							businessid cbbusinessid,-- 客户商机ID
							businessno,-- 客户商机编号
							custid cbcustid,-- 客户ID
							businessname,-- 客户商机名称
							deptid, deptname,
							predictsumprice,-- 预计总价
							year cbyear,-- 商机年度
							status cbstatus,--  '状态(1-未生效，2-已生效，3-变更中)',IDFS000079
							getcustname(custid) custname,-- 客户名称
							applyfigure,-- 客户商机金额
							createdate cbcreatedate,-- 创建时间
							salecost,-- 预算人工总额
							getusername(applyuserid) cbapplyusername,
							getusername(principal) cbprincipalname
					from t_sale_customerbusiness
			) cb
			left join `t_report_custsummary` c on c.businessid = cb.cbbusinessid and c.`year` = cb.`cbyear`

			UNION ALL -- ==================================================================================

			select 
				presaleid,'售前预算' as type,1 as typevalue,presaleno,businessname, (
				tall.deptid),principalname,getusername(userid),
				case when year = 2018 then predictexpense else 0 end pfamt,
				case when year = 2018 then infoex3 else 0 end as pramt,
				1718
			from T_Sale_Presales tall
			WHERE year >= 2017
			GROUP BY presaleid
		) budget
) base

left join -- 实际费用
(
		SELECT
			unit.calcdept,unit.linename, voucher.depid,
			reim.budgetid,reim.budgetnature,reim.budgettype, reim.extend1,
			SUM(CASE	WHEN (`invoi`.`invoicetype` = '3') THEN `invoi`.`bta` ELSE `invoi`.`amt` END) sjfy
		FROM t_budget_paymentbill voucher
		JOIN `t_budget_reimbursement` `reim` ON `reim`.`paymentid` = `voucher`.`id`
		JOIN `t_budget_reimbursementdetail` `invoi`
		 ON `reim`.`id` = `invoi`.`reimbursementid` and `invoi`.`course` NOT IN ('161', '163')
		JOIN t_sys_mngunitinfo unit on unit.unitid = voucher.depid
		where left(voucher.acctdate, 6) in (201801,201802,201803)
-- 		WHERE left(voucher.acctdate,4)=2018
		GROUP BY reim.extend1
)realfee on base.`no` = realfee.extend1

left join -- 手录记账费用(有预算编号)
(
		SELECT 
			extend1, prono,		
			SUM(case when course in (50, 1258) then payamount else 0 end) fy1, -- 商品销售成本
			SUM(case when course in (SELECT subjectid from t_budget_accountingsubject WHERE level1value like '%6301%' or level1value like '%6111%') then -payamount when course in (50,1258) then 0 else payamount end ) fy2-- 其他调整成本
		from t_budget_paymentbill_manual
		WHERE  1=1
			and extend1 not in (12, '') 
-- 			and LEFT(acctdate,4)=2018
			and acctdate in (201801,201802,201803)
		GROUP BY prono
)fy on base.`no` = fy.prono

left join -- 标准成本
(
		SELECT
			budgetid, budgetno, budgetname,-- deptid, yearmonth, company,
			SUM(card1cost+card2cost) gz,-- 标准成本
			null gzdiff, -- 工资成本差异
			SUM(salary13cost+bonuscost) jj-- 标准成本13薪
		FROM `t_project_standardcost`
		WHERE yearmonth in (201801, 201802, 201803)
		GROUP BY budgetid
)cb1 on base.`id` = cb1.budgetid


left join (-- 实际成本
		SELECT
			SUBSTRING_INDEX(projectno,'-',1),projectno,
			SUM(debitamount) sjgz
		FROM `t_cost_voucherexport`
		WHERE myear = 2018 and mmonth in ('01','02','03')
		GROUP BY projectno
)cb3 on base.`no` = cb3.projectno

left JOIN
(
		SELECT unitid, linename, calcdept, remark4
		from t_sys_mngunitinfo
)unit on unit.unitid = base.unitid

where 
1=1
and base.`no` != ''
and (realfee.sjfy || fy.fy1 || fy.fy2 || cb1.gz || cb1.gzdiff || cb1.jj || cb3.sjgz)
-- {no}
-- {calcdeptname}
-- 
union all

SELECT 
		'人力成本差异', null, '人力成本差异' type,null, null,
		null,null, null, null, null,
		null,null, gzdiff, null, null,
		calcdept calcdeptname,linename, remark4 deptname
FROM
(
		SELECT 
			(SELECT remark4 from t_sys_mngunitinfo WHERE brno like deptid LIMIT 1) remark4,
			(SELECT linename from t_sys_mngunitinfo WHERE brno like deptid LIMIT 1) linename,
			(SELECT calcdept from t_sys_mngunitinfo WHERE brno like deptid LIMIT 1) calcdept,
			deptid unitid,
			SUM(gz) gzdiff,-- 人力成本差异
			budgetid, budgetno, budgetname
		from t_project_standardcost_gz
		where yearmonth in (201801,201802,201803) and gzcourse in (64010502, 64010504)
		GROUP BY budgetid, deptid
)gzdiff

union all

SELECT
		'部门调整费用' `no`, null, '部门调整费用' type,null, null,
		null,null, null, fy2, null,
		null,null, null, null, null,
		calcdept calcdeptname, linename, remark4 deptname
FROM
(
		SELECT 
			b.calcdept, b.linename, b.remark4,
			SUM(case when course in (SELECT subjectid from t_budget_accountingsubject WHERE level1value like '%6301%' or level1value like '%6111%') then -payamount when course in (50,1258) then 0 else payamount end ) fy2-- 其他调整成本
		from t_budget_paymentbill_manual a, t_sys_mngunitinfo b
		WHERE 
			extend1 in (12, '')	and acctdate in (201801,201802,201803)
			and a.depid = b.unitid
		GROUP BY b.calcdept
)bmfy

ORDER BY `no`