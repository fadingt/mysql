SELECT
-- 				projectid id,
-- 				projectno `no`,
-- 				projectname `name`,
				SUM(base.cgcb),
				SUM(fy.fy1+fy.fy2) mfy,
				SUM(base.sjfy),
				sum(realfee.amt)

		FROM
		(
					SELECT
					projectid,
					projectno,
					projectname,
					deptid,
					translatedict ('IDFS000070', projstatus) projstatusname,
					IFNULL(translatedict ('IDFS000091', projecttype),'') projecttypename,
					IFNULL(translatedict ('IDFS000092', businesstype),'') businesstypename,
					SUM(fee) fee,-- 预计费用
					SUM(cost) cost,-- 预计成本
					SUM(yjcb_cg) yjcb_cg, -- 预计采购
-- 					SUM(jan_sjcb+feb_sjcb+mar_sjcb) sjcb,-- 一季度实际成本
					sum(jan_sjfy+feb_sjfy+mar_sjfy) sjfy,-- 一季度实际费用
					SUM(jan_cgcb+feb_cgcb+mar_cgcb) cgcb -- 一季度采购成本
				from t_report_projectinfoinout
				where nowyear = 2018
				GROUP BY projectid
		)base

left join -- 实际费用
(
		SELECT
			unit.calcdept,unit.linename, voucher.depid,
			reim.budgetid,reim.budgetnature,reim.budgettype, reim.extend1,
			SUM(CASE	WHEN (`invoi`.`invoicetype` = '3') THEN `invoi`.`bta` ELSE `invoi`.`amt` END) amt
		FROM t_budget_paymentbill voucher
		JOIN `t_budget_reimbursement` `reim` ON `reim`.`paymentid` = `voucher`.`id`
		JOIN `t_budget_reimbursementdetail` `invoi`
		 ON `reim`.`id` = `invoi`.`reimbursementid` and `invoi`.`course` NOT IN ('161', '163')
		JOIN t_sys_mngunitinfo unit on unit.unitid = voucher.depid
		where left(voucher.acctdate, 6) in (201801,201802,201803)
-- 		WHERE left(voucher.acctdate,4)=2018
		GROUP BY reim.extend1
)realfee on base.`projectno` = realfee.extend1

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
)fy on base.`projectno` = fy.prono
WHERE base.sjfy || base.cgcb
GROUP BY base.`projectno`