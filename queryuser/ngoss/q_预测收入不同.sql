SELECT
*
from
(
		SELECT mar_yjsr, apr_yjsr, may_yjsr, jun_yjsr, projectno, projectid
		FROM `t_report_projectinfoinout` 
		where 
-- projectno like 'YY-2018-0537-01'
-- 		and 
nowyear like 2018-- and mar_yjsr != 0
)a
left join
(
		SELECT M_1_income, projectno, m1_month
		FROM `t_project_pre12income`
		WHERE m1_month = 201804 and M_1_income != 0
-- 		and projectno like 'YY-2018-0537-01'
)b on a.projectno = b.projectno
WHERE a.apr_yjsr != b.M_1_income
