SELECT
billid, billno
unitname,
getusername(userid),
userdepname,
-- SUM(payamount) 
payamount,
paycontent,`status`,
SUBJECT.level2value,
`subject`.level2text

FROM t_budget_paymentbill voucher
JOIN `t_budget_reimbursement` `reim` ON `reim`.`paymentid` = `voucher`.`id`
JOIN `t_budget_reimbursementdetail` `invoi` ON `reim`.`id` = `invoi`.`reimbursementid` and `invoi`.`course` NOT IN ('161', '163')
where left(acctdate, 4) = 2017
and depid = 15
and course = 660201-- 差旅费
-- GROUP BY depid, course
;
SELECT
lineid,
getunitname(lineid),
(jt+cl+zd+tx+bg+fl+gwc+bx+bgszl+qtzl+cw+gz),
(s_gz+s_wxyj),
(prjamt+deptamt)
FROM `t_report_feiyong_tian`
where acctdate = 2017
and lineid = 15
;
SELECT
billid,
SUM(amt)
FROM `report_reimbursement_paymentbill`
WHERE figuredeptid =15
and levela like '差旅费用'
and acctyear =2017
and paystatus = '已支付'
GROUP BY billid
;
SELECT
bill.id,
sum(invoi.bta),
sum(invoi.amt),
CASE	WHEN (`invoi`.`invoicetype` = '3') THEN `invoi`.`bta` ELSE `invoi`.`amt` END
from `t_budget_paymentbill` `bill`
JOIN `t_budget_reimbursement` `reim` ON `reim`.`paymentid` = `bill`.`id`
JOIN `t_budget_reimbursementdetail` `invoi` ON  `reim`.`id` = `invoi`.`reimbursementid`	
WHERE `invoi`.`course` NOT IN ('161', '163')
and bill.id in (15916,32927,36324,36332,36361)
GROUP BY bill.id

-- SELECT
-- -- unitname,
-- SUM(payamount)
-- 
-- FROM t_budget_paymentbill voucher
-- JOIN t_budget_paymentbillcourse course ON voucher.id = course.billid
-- where left(acctdate, 4) = 2017
-- -- and course not in ('660224','222105','2221010402','222108','22210102','640124','*640124')
-- and course not like '2221010%'
-- GROUP BY depid
-- ;
-- SELECT
-- lineid,
-- getunitname(lineid),
-- SUM(jt+cl+zd+tx+bg+fl+gwc+bx+bgszl+qtzl+cw+gz),
-- SUM(s_gz+s_wxyj),
-- SUM(prjamt+deptamt)
-- FROM `t_report_feiyong_tian`
-- where acctdate = 2017
-- GROUP BY lineid
-- ;
-- 
-- SELECT DISTINCT
-- course,
-- SUBJECT.level1value,
-- SUBJECT.level2text
-- FROM t_budget_paymentbill voucher
-- JOIN t_budget_paymentbillcourse course ON voucher.id = course.billid
-- JOIN t_budget_accountingsubject subject on SUBJECT.level2value = course.course
-- WHERE SUBJECT.level2text like '%税%'
-- ;