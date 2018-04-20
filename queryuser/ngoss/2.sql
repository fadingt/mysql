SELECT
predictenddate,
extend1
from t_project_stepbudget
WHERE projectid = 28687
 and templateid = 50334
;
-- 20151130	20151018
SELECT 
predictenddate,
jswcrq
from t_project_stage_ys_tian
WHERE projectid = 28687 and templateid = 50334
;

SELECT
* from
(
		SELECT
			a.projectid, a.templateid,b.stageid,
			(a.predictenddate),
			(a.extend1)
		from t_project_stepbudget a,t_contract_project_stage b
		WHERE a.projectid = b.projectid and a.templateid = b.projectstageid
and b.stageid=1535
-- 		GROUP BY b.extend1, b.stageid
ORDER BY a.projectid
) x WHERE projectid = 28687 and templateid = 50334
;