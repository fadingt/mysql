
select *
from
(
		SELECT projectid, version, projectno, projectname, budgetcontractamout FROM t_project_projectinfo WHERE projectno like '%yy%'
)a
left join
(
		SELECT version, projectid, budgetcontractamout FROM `t_project_projectinfo_tmp` WHERE opertype = 2 and approvestatus = 2
)b on a.projectid = b.projectid
