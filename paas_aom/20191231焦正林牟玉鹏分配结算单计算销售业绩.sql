SELECT t.*
from (
	SELECT 
	o.ID oid, o.S_STACODE `结算单编号`, o.S_STANAME `结算单名称`, o.DL_STATEMAMT `结算单金额`, o.DT_PRSIGNDT `预转实日期`, 
	SUM(ass.DL_PRBILLAMT) `分配金额`,
-- 	SUM(case sacase.S_SIGNTYPE when 1 then ass.DL_PRBILLAMT else 0 END) `分配人月事项金额`,
-- 	SUM(case sacase.S_SIGNTYPE when 2 then ass.DL_PRBILLAMT else 0 END) `分配按人月结算的开发成果类事项金额`,
-- 	SUM(case sacase.S_SIGNTYPE when 3 then ass.DL_PRBILLAMT else 0 END) `分配任务单事项金额`,
	GROUP_CONCAT(DISTINCT sacase.S_CASECODE) `事项编号`, GROUP_CONCAT(prj.S_PRJNO) `项目编号`,
	case sacase.S_SIGNTYPE when 1 then '人月' when 2 then '按人月结算的开发成果类' when 3 then '任务单' END `签约子类型`
	from mdl_aos_sastatem o
	left join mdl_aos_saordass ass on ass.I_STATEID = o.ID
	left join mdl_aos_project prj on prj.id = ass.I_PROID
	left join mdl_aos_sacase sacase on sacase.I_POID = prj.I_POID
	where o.IS_DELETE = 0 and ass.IS_DELETE = 0 and prj.IS_DELETE = 0
	GROUP BY o.ID, sacase.S_SIGNTYPE
-- sacase.ID
)t
join (
	SELECT 
		DISTINCT o.ID
	from mdl_aos_sastatem o
	left join mdl_aos_saordass ass on ass.I_STATEID = o.ID
	left join mdl_aos_project prj on prj.id = ass.I_PROID
	left join mdl_aos_sacase sacase on sacase.I_POID = prj.I_POID
	where o.IS_DELETE = 0 and ass.IS_DELETE = 0 and prj.IS_DELETE = 0
	GROUP BY o.ID HAVING COUNT(DISTINCT sacase.S_SIGNTYPE) > 1
)t1 on t.oid = t1.id
