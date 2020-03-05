SELECT
	projectid,
	projectno `项目编号`, projectname `项目名称`,
	ngoss.getcompanyname(company) `财务主体`,
	yearmonth `年月`, ngoss.getusername(pm) `项目经理`, ngoss.getusername(pd) `项目总监`, 
	salename `销售代表`, salearea `销售大区`,	custname `客户名称`,
	projecttypename `项目类型`, prjstatusname `项目状态`, incometypename `项目收入类型`, incometype2, incometype,
	ngoss.translatedict('INCOMEWAY', incometype2) `当月收入类型`,
	startdate `开始日期`, enddate `结束日期`, maintaincedate `维护日期`, asigndate `签约日期`, filedate `归档日期`,
	prjtaxrate `利率`, budgetcontractamt `预算合同额`,
	budgetincome `预计收入`, cumulativecost `累计成本`, predictcost `预计成本`,cumulativeincome `累计收入`,
-- 	ngoss.translatedict('isBaseon',isBaseon) `依据状态`,
case isBaseon when 0 then '无' when 1 then '充分' when 2 then '不充分' when 3 then '作废' else null end `依据状态`,
	curmonincome `收入`,
	adjustincome `收入调整`,
	curmontax `销项税金`,
	adjusttax `销项税金调整`	
FROM `t_snap_income_projectincome_final`
where calctype != 0 or calctype is NULL