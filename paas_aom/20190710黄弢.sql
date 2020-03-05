select 
(select REAL_NAME from plf_aos_auth_user where id = da.S_APPLICANT) '申报员工姓名', 
da.DT_WORKDATE '申报日期', '2019' as '考勤年份', DATE_FORMAT(da.DT_WORKDATE,'%m') as '考勤月份',
(select DICT_NAME from plf_aos_dictionary where da.S_DAILYTYPE = DICT_CODE and DICT_PARENT_CODE = 'AttendType') '考勤状态', 
(select DICT_NAME from plf_aos_dictionary where da.S_DATETYPE = DICT_CODE and DICT_PARENT_CODE = 'dateType') '日期类型' , 
(select DICT_NAME from plf_aos_dictionary where da.S_WORKTYPE = DICT_CODE and DICT_PARENT_CODE = 'DoWorkType') '工时类型',
S_PROSTAGE '项目阶段ID' ,S_STAGENAME '项目阶段名称',
	S_WORKTIMES '工时时长',	
(select DICT_NAME from plf_aos_dictionary where da.S_APPSTATUS = DICT_CODE and DICT_PARENT_CODE = 'ReimState') '审批状态',	
(select REAL_NAME from plf_aos_auth_user where id = da.S_APPROVER)'审批人',
 da.LAST_UPDATE_TIME	'提交审批时间'	,p.ID'项目ID'	,S_BGCODE'项目编号'	,
S_BGNAME '项目名称'	, 
(select DICT_NAME from plf_aos_dictionary where p.S_PRJCLASS = DICT_CODE and DICT_PARENT_CODE = 'PRJCLASS')  '项目类型',	
case LENGTH(da.S_BUGETDPT)
when 10 then org1.ORG_NAME
when 13 then CONCAT(org1.org_name,'-', org2.org_name)
when 16 then CONCAT(org1.org_name,'-', org2.org_name, '-', org3.org_name) 
end '预算归属部门',
-- '财务主体',
-- case when da.S_BUDGETYPE in ('YY','YF') then ngoss.getfullorgname(p.S_DEPT) else ngoss.getfullorgname(da.S_BUGETDPT) end '预算归属部门',
(select REAL_NAME from plf_aos_auth_user where id = S_SALEOWNER) '项目销售',
(select REAL_NAME from plf_aos_auth_user where id = p.S_MANAGER)  '项目经理',	
(select REAL_NAME from plf_aos_auth_user where id = p.S_DIRECTOR) '项目总监' ,
T_ADDRESS '项目工作地点', S_CUSTNAME '客户名称',
p.S_AREA '项目工作地点邮编'
 from mdl_aos_dawork da 
left join mdl_aos_project p on da.S_PROJECT = p.ID 
left join mdl_aos_sapnotify pn on p.I_PRJNOTICE = pn.ID
left join mdl_aos_sapoinf po on pn.I_POID = po.ID
left join mdl_aos_sacustinf cu on po.I_CUSTID = cu.ID

left join plf_aos_auth_org org1 on org1.ORG_CODE = left(IFNULL(p.S_DEPT,da.S_BUGETDPT),10)
left join plf_aos_auth_org org2 on org2.ORG_CODE = left(IFNULL(p.S_DEPT,da.S_BUGETDPT),13)
left join plf_aos_auth_org org3 on org3.ORG_CODE = left(IFNULL(p.S_DEPT,da.S_BUGETDPT),16)

where da.IS_DELETE = 0
and DATE_FORMAT(DT_WORKDATE,'%Y%m') = 201905
