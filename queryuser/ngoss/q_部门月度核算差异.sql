SELECT
't_report_feiyong_tian',
t1.*,
't_dept_costincome',
t2.*
FROM
(
		SELECT SUM(jt), calcdept, acctdate
		FROM `t_report_feiyong_tian` a
		GROUP BY calcdept, acctdate
)t1
left JOIN
(
		SELECT SUM(jt), lineid, left(yearmonth,4) as year2
		FROM `t_dept_costincome`
		GROUP BY lineid, left(yearmonth,4)
)t2 on t1.calcdept = t2.lineid and t1.acctdate = t2.year2
WHERE acctdate = 2018