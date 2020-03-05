SELECT 
b.*, a.*
from (
	SELECT
	projectid,DATE_FORMAT(CONCAT(yearmonth,'01'),'%Y/%m/%d') yearmonth,
	sum(level2) as level2,
	sum(level3) as level3,
	sum(level4) as level4,
	sum(level5) as level5,
	sum(level6) as level6,
	sum(level7) as level7,
	sum(level8) as level8,
	sum(level9) as level9,
	sum(level10) as level10,
	sum(level11) as level11,
	sum(level12) as level12,
	sum(level13) as level13,
	sum(level14) as level14
	FROM `t_project_monthbudget` a
	where yearmonth BETWEEN 201809 and 201812
	GROUP BY projectid, yearmonth
)a
-- 764
join (
	SELECT 
	(SELECT linename from t_sys_mngunitinfo where unitid = deptid) linename,
-- translatedict('IDFS000070', projstatus),
	projectid, projectno, projectname, translatedict('IDFS000070',projstatus) prjstatus
	from t_project_projectinfo
	where (SELECT linename from t_sys_mngunitinfo where unitid = deptid) like '%应用开发部'
and projstatus in (1,2)
-- ORDER BY (SELECT linename from t_sys_mngunitinfo where unitid = deptid)
)b on a.projectid = b.projectid
-- where b.projectid is null
-- where SUBSTRING_INDEX(b.projectno ,'-',1) = 'zl'
ORDER BY b.linename, a.projectid, a.yearmonth