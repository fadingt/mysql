SELECT 
b.*,
-- a.nowyear,
a.realincom,
a.realincom1
FROM
(
		SELECT 
		projectid,
--  nowyear,
		SUM(realincom) realincom1,
		SUM(IFNULL(Jan_sjsr,0)+IFNULL(Feb_sjsr,0)+IFNULL(Mar_sjsr,0)+IFNULL(Apr_sjsr,0)+IFNULL(May_sjsr,0)+IFNULL(Jun_sjsr,0)+IFNULL(Jul_sjsr,0)+IFNULL(Aug_sjsr,0)+IFNULL(Sep_sjsr,0)+IFNULL(Oct_sjsr,0)+IFNULL(Nov_sjsr,0)+IFNULL(Dec_sjsr,0)) realincom
		from t_report_projectinfoinout
		GROUP BY projectid
-- , nowyear
) a
JOIN
(
		SELECT
		projectid,projectno,
-- projectname,
-- LEFT(yearmonth,4) nowyear2,
		SUM(curmonincome+adjustincome+taxfreeincome) realincome,
		SUM(curmonincome) income1,
		SUM(adjustincome) income2,
		SUM(taxfreeincome) income3
		from t_income_prjmonthincome_fi
		GROUP BY projectid
-- , left(yearmonth,4)
) b on a.projectid = b.projectid 
-- and a.nowyear = b.nowyear2
WHERE a.realincom != b.income1
;

SELECT * from t_income_prjmonthincome_year
-- WHERE 
-- year = 2018
-- and 
-- projectid = 2688
ORDER BY projectid
;