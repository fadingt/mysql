SELECT
a.budgetno `项目编号`, a.budgetname `项目名称` ,a.username `员工姓名`, a.startdate `开始时间`, a.enddate `结束时间`, a.yearmonth `报工年月`, a.worktimes_1 `报工天数`,
a.salename `卖价角色`, a.saleamt `人月卖价`, a.daysaleamt `人天卖价`, a.curmonincome `收入额`, a.curmontax `销项税`
-- ''
from(
	SELECT
	username, yearmonth, budgetid, budgetno, budgetname, worktimes_1, salename, saleamt, daysaleamt, curmonincome, curmontax,
	DATE_FORMAT(startdate,'%Y-%m-%d') startdate, DATE_FORMAT(enddate,'%Y-%m-%d') enddate, companyname
	from t_snap_project_standardcost_detail
	where saleamt <> 0
)a
join (
	SELECT a.ID, S_PRJNO
	from mdl_aos_project a
	left join mdl_aos_sacont b on a.I_POID = b.I_POID
	where S_PRJTYPE = 'YY' and a.IS_DELETE = 0 and S_PRJSTATUS <> '01' and S_PRJSTATUS <> '06'
	and b.IS_DELETE = 0 and b.DT_FILEDATE is null
)b on a.budgetid = b.ID