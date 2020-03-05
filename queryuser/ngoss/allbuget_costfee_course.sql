		SELECT
			IFNULL(b.level2text, courseno) coursename, '实际成本', projectno, CONCAT(myear,mmonth) yearmonth, SUM(debitamount) amt
		FROM `t_cost_voucherexport` a
		left join t_budget_accountingsubject b on b.level2value = a.courseno
		WHERE debitamount <> 0
		GROUP BY courseno, projectno, myear, mmonth

		union all

		SELECT
			IFNULL(`subject`.level2text, invoi.course), '实际费用', reim.extend1, voucher.acctdate,
			SUM(CASE	WHEN (`invoi`.`invoicetype` = '3') THEN `invoi`.`bta` ELSE `invoi`.`amt` END) sjfy
		FROM t_budget_paymentbill voucher
		JOIN `t_budget_reimbursement` `reim` ON `reim`.`paymentid` = `voucher`.`id`
		JOIN `t_budget_reimbursementdetail` `invoi`	 ON `reim`.`id` = `invoi`.`reimbursementid` 
		JOIN t_budget_accountingsubject `subject` on `subject`.subjectid = invoi.course
		where 1=1 
			and `invoi`.`course` NOT IN ('161', '163')
			and left(acctdate,4) >= 2018
		GROUP BY invoi.course, reim.extend1, acctdate

		unIon all

		SELECT 
			 b.level2text, '手录记账费用', prono, acctdate,
			SUM(case when level1value like '%6301%' or level1value like '%6111%' then -payamount else payamount end) fy1
		from t_budget_paymentbill_manual a, t_budget_accountingsubject b
		WHERE  a.course = b.subjectid
		GROUP BY course, prono, acctdate

		union all

		SELECT
			IFNULL(level2text, card2_1course),'标准成本', budgetno, yearmonth,
			SUM(card1cost+card2cost) gz
		FROM `t_project_standardcost` a
		left join t_budget_accountingsubject b on a.card2_1course = b.level2value
		GROUP BY card2_1course, budgetno, yearmonth

		union all

		SELECT
			level1text, '标准成本13薪', budgetno, yearmonth,
			SUM(salary13cost+bonuscost) jj
		FROM `t_project_standardcost` a, t_budget_accountingsubject b
		WHERE  a.jjcourse = b.level2value
		GROUP BY jjcourse, budgetno, yearmonth
