SELECT
	b.calcdept,
	SUM(fy1+fy2),
	SUM(fy1),
	SUM(fy2)
FROM
(		
		SELECT
			depid,
			SUM(case when course in (50, 1258) then payamount else 0 end) fy1, -- 商品销售成本
			SUM(case when course in (SELECT subjectid from t_budget_accountingsubject WHERE level1value like '%6301%' or level1value like '%6111%') then -payamount when course in (50,1258) then 0 else payamount end ) fy2-- 其他调整成本
		from t_budget_paymentbill_manual a
		WHERE left(acctdate,4) =2018
		GROUP BY depid
)a
		join t_sys_mngunitinfo b on a.depid = b.unitid
		GROUP BY b.calcdept
