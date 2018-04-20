SELECT
	x.targetid,
	x.projectno,
-- 	x.projectstageid,
	x.projectname,
-- 	x.yearmonth,
	SUM(x.employeeid)
FROM
(
		SELECT 
			employeeid, username, yearmonth, yearmonthday, travelstatus, travelstatusname, 
			workhourtype, workhourtypename, holidaystatus, holidaystatusname,
			`status`, statusname, targetid, projectstageid, projectstagename, projectno, projectname
		FROM `t_report_workhourdetail`
		WHERE `status` = 3 
-- and workhourtype = 0
-- and  projectname like '%九盈%'
and targetid = 160
-- and projectno like 'SQ%'
and employeeid = 31322
ORDER BY yearmonth
)x
GROUP BY
	x.targetid
-- , x.projectstageid