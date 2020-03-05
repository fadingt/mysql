set @yearmonth_max := 201803;
set @yearmonth_min := 201801;
select 
	base.*,
	IFNULL(sf.sjfy,0) totalused, -- 实际费用
	ifnull(r.ramt,0) ramt, -- 预计人力成本
	ifnull(sr.sjgz,0) usedcost -- 已使用人力成本
from
(
	select 
		budgetid, budgetno, budgetname, budgettype, budgetdescription,budgetnature,-- 预算编号 名称 类型 描述
		SUBSTRING_INDEX(getLevelDeptNameByTian(departmentid),'-',2) departmentname , -- 所属部门名称
		startdate, enddate, -- 开始结束日期 
		budgetamount, -- 预算费用总金额
		getusername(chargeperson) chargepersonname, getunitname(company) companyname-- 预算负责人 公司名称
	from t_budget_deptannualbudget
	where budgetnature = '1'

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
		where left(voucher.acctdate, 6) between @yearmonth_min and @yearmonth_max
-- 		WHERE left(voucher.acctdate,4)=2018
		GROUP BY reim.extend1
)sf on base.`budgetno` = sf.extend1

left join -- 预计人力成本
(
	select 
		budgetid, deptid, sum(infoex2) ramt
	from  t_budget_deptlevelcost
	GROUP BY budgetid
)r on r.budgetid = base.budgetid 

left join (-- 实际人力成本
		SELECT
			SUBSTRING_INDEX(projectno,'-',1),projectno,
			SUM(debitamount) sjgz
		FROM `t_cost_voucherexport`
		WHERE myear = 2018 and mmonth BETWEEN SUBSTR(@yearmonth_min FROM 5 FOR 2) and SUBSTR(@yearmonth_max FROM 5 FOR 2)
		GROUP BY projectno
)sr on base.`budgetno` = sr.projectno


where 1=1

-- {budgetno}
-- {inputdate}
-- {department}
-- {budgetname}
 order by budgetno
;