SELECT
*
FROM
(
		SELECT 
		projectno,
		SUM(curmonincome+adjustincome+taxfreeincome) income1,
		SUM(curmonincome+adjustincome) income2,
		SUM(taxfreeincome)
		from t_income_prjmonthincome_fi
-- WHERE projectno like 'YY-2012-0082'
		GROUP BY projectid
)a
JOIN
(
		SELECT
			projectno, year, company, qc_income, qm_income, year_taxfree, year_income
		FROM t_income_prjmonthincome_year a
		WHERE year = (SELECT MAX(year) from t_income_prjmonthincome_year WHERE projectid = a.projectid GROUP BY projectid)
GROUP BY projectid
)b on a.projectno = b.projectno
WHERE a.income2 != b.qm_income
;
		SELECT 
		projectno,(curmonincome+adjustincome+taxfreeincome) income1,(curmonincome),(taxfreeincome), yearmonth
		from t_income_prjmonthincome_fi
WHERE projectno like 'YY-2012-0082'
;
		SELECT
projectno, year, company, qc_income, qm_income, year_taxfree, year_income
		FROM t_income_prjmonthincome_year
WHERE projectno like 'YY-2012-0082'
;
