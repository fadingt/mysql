SELECT 
x.projectid,
CONCAT(x.sumsbillamt,',',x.yearmonth)
FROM
(
		SELECT 
		projectid, left(sbilldate,6) yearmonth,
		SUM(sbillamt) sumsbillamt
		from t_project_stage_ys_tian
		where sbilldate is not null and left(sbilldate,6) > 201612
		GROUP BY projectid, left(sbilldate,6)
		ORDER BY projectid
)x