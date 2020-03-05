SELECT
*
from
(
		SELECT depid, SUM(payamount), acctdate FROM `t_budget_paymentbill_manual`
		WHERE prono = ''
		and acctdate in ('201801','201802','201803')
		GROUP BY depid
)x
left JOIN
(
		SELECT unitid, linename, calcdept, remark4
		from t_sys_mngunitinfo
)d on d.unitid = x.depid
;

-- SELECT 
-- billno,
-- getusername(userid),
-- userdepname,
-- unitname,
-- depbrno,
-- payamount,
-- acctdate,
-- extend2
-- from t_budget_paymentbill_manual
-- WHERE prono = ''
-- 		and acctdate in ('201801','201802','201803');