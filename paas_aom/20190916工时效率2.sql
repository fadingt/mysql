select 
'通过',
appuser.REAL_NAME '申报员工姓名', APPROVER.REAL_NAME '审批人',
case da.S_DAILYTYPE when 0 then '本地' when 1 then '出差' else '其他假期' end '考勤状态', -- AttendType
case da.S_DATETYPE when 1 then '工作日' when 2 then '休息日' when 3 then '法定假日' when 4 then '法定休息日' end `日期类型`,
case da.S_DAILYTYPE when 0 then '项目执行中' when 1 then '售前活动' when 2 then '部门活动' when 3 then '专项' when 4 then '客户商机' end '工时类型',
S_BGCODE'项目编号', S_BGNAME '项目名称',
S_PROSTAGE '项目阶段ID' ,S_STAGENAME '项目阶段名称', S_WORKTIMES '工时时长',	
 da.LAST_UPDATE_TIME	'提交审批时间', da.DT_WORKDATE '申报日期', 
p.*
from mdl_aos_dawork da
join (
		SELECT
		p.ID, p.S_PRJNO,
		ngoss.getfullorgname(p.S_DEPT) '预算归属部门',
		(select REAL_NAME from plf_aos_auth_user where id = S_SALEOWNER) '项目销售',
		(select REAL_NAME from plf_aos_auth_user where id = p.S_MANAGER)  '项目经理',	
		(select REAL_NAME from plf_aos_auth_user where id = p.S_DIRECTOR) '项目总监' ,
		T_ADDRESS '项目工作地点', S_CUSTNAME '客户名称'
		from mdl_aos_project p
		LEFT JOIN mdl_aos_sapnotify pn on p.I_PRJNOTICE = pn.ID
		left join mdl_aos_sapoinf po on pn.I_POID = po.ID
		left join mdl_aos_sacustinf cu on po.I_CUSTID = cu.ID
		where p.IS_DELETE = 0
)p on da.S_PROJECT = p.ID
join plf_aos_auth_user appuser on appuser.id = da.S_APPLICANT
join plf_aos_auth_user APPROVER on APPROVER.id = da.S_APPROVER
where 1=1
and da.IS_DELETE = 0
and da.S_WORKTYPE = 0
and da.S_APPSTATUS = 1
-- and DATE_FORMAT(DT_WORKDATE,'%Y%m') = DATE_FORMAT(NOW(),'%Y%m')


union all



select 
'通过',
appuser.REAL_NAME '申报员工姓名', APPROVER.REAL_NAME '审批人',
case da.S_DAILYTYPE when 0 then '本地' when 1 then '出差' else '其他假期' end '考勤状态', -- AttendType
case da.S_DATETYPE when 1 then '工作日' when 2 then '休息日' when 3 then '法定假日' when 4 then '法定休息日' end `日期类型`,
case da.S_DAILYTYPE when 0 then '项目执行中' when 1 then '售前活动' when 2 then '部门活动' when 3 then '专项' when 4 then '客户商机' end '工时类型',
S_BGCODE'项目编号', S_BGNAME '项目名称',
S_PROSTAGE '项目阶段ID' ,S_STAGENAME '项目阶段名称', 
S_WORKTIMES '工时时长',	 da.LAST_UPDATE_TIME	'提交审批时间', da.DT_WORKDATE '申报日期', 
null, null, NULL, null, null, null, null, null
from mdl_aos_dawork da
join plf_aos_auth_user appuser on appuser.id = da.S_APPLICANT
join plf_aos_auth_user APPROVER on APPROVER.id = da.S_APPROVER
where 1=1
and da.IS_DELETE = 0
and da.S_WORKTYPE != 0
and da.S_APPSTATUS = 1