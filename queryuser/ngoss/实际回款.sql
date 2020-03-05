SELECT
*
FROM(
		select 
			projectid, sum(p_yreceamt) as receamta
		from view_project_srece_tian
-- 		WHERE left(msrecedate,4) = 2018
		GROUP BY projectid
)a
left join(
		SELECT 
			projectid, SUM(paymented) receamtb
		from t_contract_project_stage
-- 		WHERE left(extend2,4) =2018
		GROUP BY projectid
)b on a.projectid = b.projectid
left join(
		SELECT
				projectid, SUM(sreceamt) receamtc
		from t_project_stage_ys_tian
-- 		WHERE left(srecedate,4) =2018
		GROUP BY projectid
)c on a.projectid = c.projectid
WHERE 1=1 
and receamta != receamtc
