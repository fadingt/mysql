SELECT 
*
from 
(
	SELECT
	b.projectid,
			d.projectno,
			b.stageid,
b.projectstageid,
			max(c.predictenddate) jsyjwcdate,
			max(c.extend1) jsqrwcdate,
			d.predictenddate projpredictenddate,
			d.jswcrq projjswcrq,
			d.projectstep,
d.ybillamt
		FROM
			t_contract_project_stage b,
			t_project_stepbudget c,
			t_project_stage_ys_tian d

		WHERE
			b.projectid = c.projectid AND b.projectid = d.projectid
		AND b.projectstageid = c.templateid AND b.projectstageid = d.templateid
		GROUP BY
			b.projectid,
			b.extend1,
			b.stageid
)x
-- join (SELECT * from t_contract_main WHERE effectstatus not in (5,8)) c on c.contractid =  x.contractid
-- WHERE x.jsqrwcdate != x.projjswcrq or x.jsyjwcdate != x.projpredictenddate
-- WHERE projectid =2700
-- WHERE 