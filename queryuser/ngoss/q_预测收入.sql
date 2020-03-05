-- SELECT SUM(jun_yjsr)
-- from t_report_projectinfoinout
-- where nowyear = 2018
-- -- 45831589.59
-- 
-- SELECT SUM(m_1_income)
-- from t_project_pre12income
-- where m1_month = 201806
-- -- 45929577.01

SELECT * from 
(
SELECT (jun_yjsr) amt1, projectid
from t_report_projectinfoinout
where nowyear = 2018
)a
left join 
(
SELECT (m_1_income) amt2, projectid, projectno
from t_project_pre12income
where m1_month = 201806
) b on a.projectid = b.projectid
where a.amt1 != b.amt2
-- 150294
-- 151045
-- 151254
-- 151256
-- 151560