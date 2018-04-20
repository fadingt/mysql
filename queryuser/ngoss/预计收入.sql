SELECT 
a.*,
b.yjsr
FROM
(
		SELECT
		projectid,
		MAX(budgetincome) budgetincome,
		MAX(budgetcontractamout) budgetcontractamout
		from t_income_prjmonthincome_fi
GROUP BY projectid
) a
LEFT JOIN
(
		SELECT
		projectid,
		SUM(income) yjsr1,
		SUM(IFNULL(Jan_yjsr,0)+IFNULL(Feb_yjsr,0)+IFNULL(Mar_yjsr,0)+IFNULL(Apr_yjsr,0)+IFNULL(May_yjsr,0)+IFNULL(Jun_yjsr,0)+IFNULL(Jul_yjsr,0)+IFNULL(Aug_yjsr,0)+IFNULL(Sep_yjsr,0)+IFNULL(Oct_yjsr,0)+IFNULL(Nov_yjsr,0)+IFNULL(Dec_yjsr,0)) yjsr
		from t_report_projectinfoinout
		GROUP BY projectid
) b on a.projectid = b.projectid
WHERE a.budgetcontractamout != b.yjsr