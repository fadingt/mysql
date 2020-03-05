-- 项目报工AOM
SELECT
	w.`项目编号`,
	u.`员工工号`, u.`员工姓名`, w.`考勤年月`, w.`员工级别`,
-- 	cal.workday `本月应报天数`,
	w.`应用项目报工天数`, w.`应用项目报工天数`*u.`标准成本` `应用项目报工成本`,
	u.`标准成本`
FROM (
		SELECT 
			w.S_APPLICANT, DATE_FORMAT(w.DT_WORKDATE,'%Y%m') `考勤年月`, w.S_WORKRANK `员工级别`,
			SUM(S_WORKTIMES/8) `应用项目报工天数`,
			w.S_BGCODE `项目编号`
		FROM paas_aom.mdl_aos_dawork w
		where 1=1
			and w.s_appstatus = 1 and w.is_delete = 0
			and w.S_DATETYPE = 1-- 工作日
			and w.s_worktype = 0 and w.S_BUDGETYPE = 'YY'
		GROUP BY w.S_APPLICANT,	DATE_FORMAT(w.DT_WORKDATE,'%Y%m'), S_BGCODE
) w
join (
		SELECT
			emp.I_USERID, S_ACCOUNT `员工工号`, emp.S_NAME `员工姓名`, emp.S_JobLevel,-- 员工职级ID(人力)
			lc.DL_TOTAMONEY `标准成本`
		from paas_aom.mdl_aos_empstaff emp
		left join paas_aom.mdl_aos_labercost lc on lc.I_LEVELNUM = emp.S_JobLevel
		where emp.S_YPSTATE = 9 and emp.OPERATION_TYPE != 'DELETE'
) u on u.I_USERID =  w.S_APPLICANT
join (-- 日历 应报天数
		SELECT COUNT(DT_CANDAY) workday, DATE_FORMAT(DT_CANDAY,'%Y%m') yearmonth
		from paas_aom.mdl_aos_canlender
		where 1=1
-- 			and DATE_FORMAT(DT_CANDAY,'%Y%m') = DATE_FORMAT(NOW(),'%Y%m')
			and S_CANTYPE = 1
		GROUP BY DATE_FORMAT(DT_CANDAY,'%Y%m')
) cal on cal.yearmonth = w.`考勤年月`
ORDER BY `项目编号`
;
-- 项目报工OA

	SELECT
	projectno `项目编号`,
	b.staffcode `员工工号`,username `员工项目`, yearmonth `考勤年月`, b.`level` `员工级别`,
	SUM(a.workhours/8) `应用项目报工天数`, 
	SUM(a.workhours*c.defaultcost/8) `应用项目报工成本`,
		c.defaultcost `标准成本`

	from t_report_workhourdetail a
	join t_hr_hrpool b on a.employeeid = b.id 
	join t_public_levelcost c on b.`level` = c.postlevel
	where a.`status` = 3
	and a.workhourtype = 0
	and projectno like 'yy%'
	GROUP BY employeeid, yearmonth, projectno


-- 项目阶段
SELECT
ngoss.translatedict('PRJSTAGE',stage.S_STAGENAME) `阶段名称`,
DATE_FORMAT(stage.DT_PSTADATE,'%Y-%m-%d') `阶段预计开始日期`,
DATE_FORMAT(stage.DT_PENDDATE,'%Y-%m-%d') `阶段预计结束日期`,
ngoss.translatedict('finiType',stage.S_FINSTATUS) `完成状态`,
ngoss.translatedict('trfl',stage.S_ISMARKER) `是否里程碑`,
project.S_PRJNO `项目编号`, project.S_PRJNAME `项目名称`
from mdl_aos_prstage stage
left join mdl_aos_project project on project.ID = stage.I_PRJID
where stage.IS_DELETE = 0 and stage.S_APPSTATUS = 1
and stage.S_STAGENAME = '06'
;