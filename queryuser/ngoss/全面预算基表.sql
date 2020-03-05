	SELECT
*
FROM
(
		SELECT
				`id`,	 `no`, `name`, `unitid`,
				CONCAT(project.projecttypename,'-',project.businesstypename) `type`,
				gfamt,	gramt
		FROM
		(
				SELECT
					projectid `id`,
					projectno `no`,
					projectname `name`,
					deptid `unitid`,
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
			budgetid `id`, budgetno `no`, budgetname `name`, unitid, type, gfamt, gramt
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
left JOIN
(
		SELECT unitid, linename, calcdept, remark4
		from t_sys_mngunitinfo
)unit on unit.unitid = base.unitid
