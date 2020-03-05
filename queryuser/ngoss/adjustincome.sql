SELECT
a.projectid, a.adjusttype,
a.adjustincome, b.adjustincome
from (
	SELECT 
	projectid, company, adjusttype, SUM(adjustincome) adjustincome, yearmonth
	from t_income_prjmonthincome_adjustments
	where adjusttype =10
	GROUP BY projectid, yearmonth, company
) a
left join (
	SELECT
	projectid, company, yearmonth, SUM(adjustincome) adjustincome
	from t_income_prjmonthincome_fi
	GROUP BY projectid, yearmonth, company
) b on a.projectid = b.projectid and a.yearmonth = b.yearmonth and a.company = b.company
where a.adjustincome != b.adjustincome

SELECT projectid, adjustincome, adjusttype, yearmonth, company from t_income_prjmonthincome_adjustments where projectid = 151026;
-- in(SELECT projectid from t_income_prjmonthincome_prjstatic where isBaseon = 0);

SELECT projectid, adjustincome, yearmonth,company from t_income_prjmonthincome_fi where projectid =151026;
-- in(SELECT projectid from t_income_prjmonthincome_prjstatic where isBaseon = 0);

SELECT projectid from t_income_prjmonthincome_prjstatic where isBaseon = 0