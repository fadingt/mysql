SELECT 
-- 	S_APPLICANT, w.S_APPROVER, 	w.S_PROSTAGE `项目阶段`, w.S_BugetDpt, porg2.ORG_NAME,
	u.`员工姓名`, S_WORKRANK `员工级别`,
	DATE_FORMAT(w.DT_WORKDATE,'%Y-%m-%d') `申报日期`, DATE_FORMAT(w.DT_WORKDATE,'%Y') `考勤年`, DATE_FORMAT(w.DT_WORKDATE,'%m') `考勤月`,
	DATETYPE.dict_name `日期类型`, DAILYTYPE.dict_name `考勤类型`,	DoWorkType.dict_name `工时类型`,
	ApproStatus.DICT_name `审批状态`, appu.REAL_NAME `审批人`,
	p.*,
	w.S_PROJECT `所属预算ID`, w.S_BGCODE `预算编号`, w.S_BGNAME `预算名称`,	w.S_BUDGETYPE `项目类型`, 	S_WORKTIMES `工时时长`,
	u.`员工类型`, u.`入职日期`, u.`员工所属部门`, u.`人员属地`, u.`员工所属部门1`, u.`员工所属部门2`
FROM mdl_aos_dawork w
join (
			SELECT
			emp.I_USERID, S_ACCOUNT `员工工号`, emp.S_NAME `员工姓名`, emp.S_JobLevel,-- 员工职级ID(人力)
			EMPTYPE.dict_name `员工类型`, DATE_FORMAT(emp.S_ENTERTIME,'%Y-%m-%d') `入职日期`,
			CONCAT(porg.S_NAME,'-',org.S_NAME) `员工所属部门`, city.S_NAME `人员属地`,
			porg.s_name `员工所属部门1`, org.s_name `员工所属部门2`
		from mdl_aos_empstaff emp
		join (
			SELECT S_ORGCODE, S_NAME, S_PORGCODE
			from mdl_aos_hrorg
			where left(S_ORGCODE,10) in (
				'0001001023', '0001001027', '0001001034', '0001001035', '0001001036', '0001001037', '0001001026', '0001001039'
				)
		) org on org.S_ORGCODE = emp.S_DEPART
		left join mdl_aos_hrorg porg on porg.S_ORGCODE = org.s_porgcode
		left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'types') EMPTYPE on EMPTYPE.dict_code = emp.S_EMPTYPE
		left join mdl_aos_city city on emp.S_SPACE = city.ID
		where emp.S_YPSTATE = 9 and emp.OPERATION_TYPE != 'DELETE'
) u on u.I_USERID =  w.S_APPLICANT
left join (
		SELECT 
			p.ID ,
			p.S_PRJNO `项目编号`, p.S_PRJNAME `项目名称`,
			org.S_NAME `项目所属部门`,
			sale.REAL_NAME `销售代表`, pm.REAL_NAME `项目经理`, pd.REAL_NAME `项目总监`,
			P.T_ADDRESS `项目工作地点`, 
-- 			P.S_AREA `项目工作地点2`,
			cust.S_CUSTNAME `客户名称`
		from mdl_aos_project p
		left join mdl_aos_sapnotify nify on nify.ID = p.I_PRJNOTICE
		left join mdl_aos_sapoinf buz on buz.ID = nify.I_POID
		left join mdl_aos_sacustinf cust on cust.ID = buz.I_CUSTID
		left join plf_aos_auth_user sale on sale.ID = cust.S_SALEOWNER
		left join mdl_aos_hrorg org on org.S_ORGCODE = p.S_DEPT
		left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
		left join plf_aos_auth_user pd on pd.ID = p.S_DIRECTOR
) p on p.ID = w.S_PROJECT



left join plf_aos_auth_user appu on appu.ID = w.S_APPROVER
left join mdl_aos_hrorg porg on porg.S_ORGCODE = w.S_BUGETDPT
-- left join plf_aos_auth_org porg2 on porg2.ORG_CODE = w.S_BUGETDPT

left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'dateType') dateType on dateType.dict_code = w.S_DATETYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'AttendType') DAILYTYPE on DAILYTYPE.dict_code = w.S_DAILYTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.dict_code = w.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'DoWorkType') DoWorkType on DoWorkType.dict_code = w.s_worktype