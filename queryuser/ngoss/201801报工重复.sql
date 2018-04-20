		
SELECT
*
FROM
(
		SELECT
		username, COUNT(yearmonthday) cnt, yearmonthday
		from t_report_workhourdetail 
		WHERE yearmonth = 201801 and travelstatus = 0
		GROUP BY username, yearmonthday
)x
WHERE cnt > 1
;

SELECT * FROM t_report_workhourdetail
WHERE yearmonth = 201801 and username = '谢思旺-A6640'
