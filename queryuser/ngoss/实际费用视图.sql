SELECT
	unit.calcdept,
	left(voucher.acctdate, 4) acctyear,
-- 	reim.extend1,
-- 	(CASE	WHEN (`invoi`.`invoicetype` = '3') THEN `invoi`.`bta` ELSE `invoi`.`amt` END) amt
	SUM(CASE	WHEN (`invoi`.`invoicetype` = '3') THEN `invoi`.`bta` ELSE `invoi`.`amt` END) amt
FROM t_budget_paymentbill voucher
JOIN `t_budget_reimbursement` `reim` ON `reim`.`paymentid` = `voucher`.`id`
-- budgetid budgetnature budgettype extend1
JOIN `t_budget_reimbursementdetail` `invoi`
 ON `reim`.`id` = `invoi`.`reimbursementid` and `invoi`.`course` NOT IN ('161', '163')
JOIN t_sys_mngunitinfo unit on unit.unitid = voucher.depid
-- where left(voucher.acctdate, 4) = 2018
where left(voucher.acctdate, 6) in (201801,201802,201803)
-- AND SUBSTRING_INDEX(reim.extend1,'-',1)  in ('zxys','bmys', 'yy', 'yf', 'qt', 'yb', 'sq')
AND SUBSTRING_INDEX(reim.extend1,'-',1)  ='yf'
-- GROUP BY unit.calcdept, left(voucher.acctdate, 4)