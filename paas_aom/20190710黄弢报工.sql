-- 项目名称 编号 所属部门 姓名 级别 报工 日期 时长 审批通过
SELECT
	budgetno '项目编号'	,budgetname'项目名称',budgetdeptname'预算归属部门',
-- stagename '项目阶段名称',
	username '员工姓名', DATE_FORMAT(workdate,'%Y-%m-%d') '申报日期',worktimes*8 '工作时长',
dailytypename '考勤状态',
datetypename '日期类型',
worktypename '工时类型'
FROM `t_snap_daily_workinghours_detail`
where 1=1
and left(workdate,6) BETWEEN 201901 and 201905
and appstatusname = '通过'
and budgettype = 'YF'
ORDER BY budgetno, username, workdate