SELECT
*
FROM
(
		SELECT 
		SUBSTRING_INDEX(projectno,'-',1),projectno,
		SUM(realcost) realcost, sum(jan_sjcb+feb_sjcb+mar_sjcb+apr_sjcb+may_sjcb) realcost2,
		SUM(jan_sjcb+feb_sjcb+mar_sjcb) realcost3
		from t_report_projectinfoinout
		WHERE nowyear =2018  
		GROUP BY projectno
)a
left join
(
		SELECT
			SUBSTRING_INDEX(projectno,'-',1),projectno,
			SUM(debitamount) debitamount
		FROM `t_cost_voucherexport`
		WHERE myear = 2018 and mmonth in ('01','02','03')
		GROUP BY projectno
)b on a.projectno = b.projectno
WHERE a.realcost3 != b.debitamount
-- WHERE a.realcost != b.debitamount
