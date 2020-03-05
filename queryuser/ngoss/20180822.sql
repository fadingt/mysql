SELECT
yearmonth,
staffcode, username, `level`,
(SELECT linename from t_sys_mngunitinfo where unitid = persondeptid),
(SELECT remark4 from t_sys_mngunitinfo where unitid = persondeptid),totaldays,
yy, yy*defaultcost,yf, yf*defaultcost,qt, qt*defaultcost,zl, zl*defaultcost,sq, sq*defaultcost,bmys, bmys*defaultcost,
`请假`,`请假`*defaultcost,`本地`,`本地`*defaultcost,`出差`,`出差`*defaultcost,defaultcost
from 
(
SELECT
a.staffcode, a.username, a.yearmonth,
persondeptid,-- 一级二级部门
(SELECT workdays FROM `t_sys_monthworkdaycount` where yearmonth = a.yearmonth) totaldays,-- 当月应报天数
SUM(case when workhourtype = 0 and SUBSTRING_INDEX(projectno,'-',1) = 'YY' then workhours/8 else 0 end) yy,
SUM(case when workhourtype = 0 and SUBSTRING_INDEX(projectno,'-',1) = 'YF' then workhours/8 else 0 end) yf,
SUM(case when workhourtype = 0 and SUBSTRING_INDEX(projectno,'-',1) = 'QT' then workhours/8 else 0 end) qt,
SUM(case when workhourtype = 0 and SUBSTRING_INDEX(projectno,'-',1) = 'ZL' then workhours/8 else 0 end) zl,
SUM(case when workhourtype = 1 then workhours/8 else 0 end ) sq,
SUM(case when workhourtype = 2 then workhours/8 else 0 end ) bmys,
SUM(case when travelstatus = 0 then workhours/8 else 0 end) '本地',
SUM(case when travelstatus = 1 then workhours/8 else 0 end) '出差',
SUM(case when travelstatus not in (0,1) then workhours/8 else 0 end) '请假',
b.`level`, c.defaultcost
FROM `t_report_workhourdetail` a, t_hr_hrpool b, t_public_levelcost c
where a.employeeid = b.id and b.`level` = c.postlevel
-- and persondeptid in (30790,30792)
and yearmonth = 201808
and a.`status` = 3
GROUP BY a.employeeid, a.yearmonth
)x
where (SELECT linename from t_sys_mngunitinfo where unitid = persondeptid) in (
'北方研发中心',
'管理应用解决方案部',
'规划咨询部',
'华北应用开发部',
'华东应用开发部',
'华南应用开发部',
'华西应用开发部',
'技术管理中心',
'架构设计部',
'科管产品部',
'南方研发中心',
'全渠道解决方案事业部管理办公室',
'网点柜面解决方案部',
'网点解决方案部',
'新产品创新解决方案部',
'业务应用解决方案部',
'移动解决方案部',
'应用开发事业部管理办公室',
'咨询事业部管理办公室'
)
ORDER BY yearmonth, persondeptid