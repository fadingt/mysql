SELECT 
b.*,
a.realincom
FROM
(
		SELECT 
		projectid, 
		SUM(realincom) realincom1,
		SUM(IFNULL(Jan_sjsr,0)+IFNULL(Feb_sjsr,0)+IFNULL(Mar_sjsr,0)+IFNULL(Apr_sjsr,0)+IFNULL(May_sjsr,0)+IFNULL(Jun_sjsr,0)+IFNULL(Jul_sjsr,0)+IFNULL(Aug_sjsr,0)+IFNULL(Sep_sjsr,0)+IFNULL(Oct_sjsr,0)+IFNULL(Nov_sjsr,0)+IFNULL(Dec_sjsr,0)) realincom
		from t_report_projectinfoinout
		GROUP BY projectid
) a
LEFT JOIN
(
		SELECT
		projectid,projectno,projectname,
		SUM(curmonincome+adjustincome+taxfreeincome) realincome
		from t_income_prjmonthincome_fi
		GROUP BY projectid
) b on a.projectid = b.projectid
WHERE a.realincom != b.realincome