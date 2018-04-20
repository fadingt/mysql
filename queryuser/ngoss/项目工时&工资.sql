SELECT
	projectid,
-- 	workmonth,
	SUM(wages)
FROM
(
		SELECT 
			projectid, userid, workmonth , username, workdays, a.workdays*b.defaultcost wages
		FROM 
			`t_project_projectpersonhour` a,
			`t_public_levelcost` b
		WHERE a.stafleve = b.postlevel
-- and workmonth > 201804 and  a.workdays*b.defaultcost <> 0
) x
GROUP BY x.projectid
-- , x.workmonth