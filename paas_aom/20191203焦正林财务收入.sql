SELECT t.*, t1.`事项预开`
from (
	-- 1框架协议：
	-- 一次性02： 计划金额 验收报告日期 是否验收
	-- 按月均摊03： 维保期内均摊 开始日期 结束日期 计划金额 是否维保
	SELECT 
	cont.S_CONCODE `合同编号`, cont.S_CONNAME `合同名称`,
	sacase.S_CASECODE `事项编号`, checkstg.DT_MAINSTART `验收阶段维保开始日期`, checkstg.DT_MAINEND `验收阶段维保结束日期`,12*(year(DT_MAINEND)-year(DT_MAINSTART)) + month(DT_MAINEND)-month(DT_MAINSTART)+1 `维保期`,
	translatedict('signType',sacase.S_SIGNTYPE) `签约子类型`,
	t.yearmonth `年月`,
	-- checkstg.DT_CHECKDATE `实际验收日期`,
	checkstg.DL_CHECKAMT/(12*(year(DT_MAINEND)-year(DT_MAINSTART)) + month(DT_MAINEND)-month(DT_MAINSTART)+1) income,
	translatedict('incomeway',checkstg.S_INCOMEWAY) `收入确认方式`
	from mdl_aos_sacont cont
	left join mdl_aos_sacase sacase on cont.I_POID = sacase.I_POID
	left join mdl_aos_sacheckstg checkstg on checkstg.I_CASEID = sacase.ID
	join (
		SELECT DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') as yearmonth
		from mdl_aos_canlender
		where DATE_FORMAT(DT_CANDAY,'%Y%m') > 201812
	) t
	where 1=1
	and checkstg.S_TYPE = 2 and checkstg.IS_DELETE = 0
	and cont.IS_DELETE = 0 and cont.S_CONTYPE = 02 and sacase.S_SIGNTYPE in(2,3)-- 按人月结算的开发成果类 任务单
	and checkstg.S_INCOMEWAY = 03 and checkstg.S_IFMAIN = 2-- 是否维保=是
	and t.yearmonth BETWEEN DATE_FORMAT(checkstg.DT_MAINSTART,'%Y%m') and DATE_FORMAT(checkstg.DT_MAINEND,'%Y%m')

	union all

	-- 2.框架协议：
	-- 人月:按项目卖价计算
	SELECT
	IFNULL(d.S_CONCODE,e.S_POCODE), d.S_CONNAME, c.S_CASECODE, null, null, null, '人月',
	 a.yearmonth, SUM(a.saleamt) income,'人月'
	from t_snap_project_standardcost_detail a
	join mdl_aos_project b on a.budgetid = b.ID and b.IS_DELETE = 0
	join mdl_aos_sacase c on c.I_POID = b.I_POID
	left join mdl_aos_sacont d on b.I_POID = d.I_POID
	left join mdl_aos_sapoinf e on b.I_POID = e.ID
	where saleamt <> 0 and c.S_SIGNTYPE = 1
	GROUP BY c.ID, c.S_CASECODE, a.yearmonth

	union all

	-- 3.固定金额
	-- 一次性02： 计划金额 验收报告日期 是否验收
	SELECT 
	cont.S_CONCODE, cont.S_CONNAME,null, null, null, null,null,
	DATE_FORMAT(checkstg.DT_CHECKDATE,'%Y%m') yearmonth, checkstg.DL_CHECKAMT income,
	translatedict('incomeway',checkstg.S_INCOMEWAY)
	from mdl_aos_sacont cont
	left join mdl_aos_sacheckapp checkapp on checkapp.I_CONID = cont.ID
	left join mdl_aos_sacheckstg checkstg on checkstg.I_CKID = checkapp.ID
	where 1=1
	and cont.IS_DELETE = 0 and cont.S_CONTYPE = 01
	and checkstg.IS_DELETE = 0 and checkstg.S_TYPE = 3
	and checkstg.S_IFCHECK = 2 and checkstg.S_INCOMEWAY = 02

	union all

	-- 按月均摊03： 维保期内均摊 开始日期 结束日期 计划金额 是否维保
	SELECT 
	cont.S_CONCODE, cont.S_CONNAME,
	null,checkstg.DT_MAINSTART, checkstg.DT_MAINEND,
	12*(year(DT_MAINEND)-year(DT_MAINSTART)) + month(DT_MAINEND)-month(DT_MAINSTART)+1 `维保期`,
	null,t.yearmonth,
	checkstg.DL_CHECKAMT/(12*(year(DT_MAINEND)-year(DT_MAINSTART)) + month(DT_MAINEND)-month(DT_MAINSTART)+1) income,
	translatedict('incomeway',checkstg.S_INCOMEWAY)
	from mdl_aos_sacont cont
	left join mdl_aos_sacheckapp checkapp on checkapp.I_CONID = cont.ID
	left join mdl_aos_sacheckstg checkstg on checkstg.I_CKID = checkapp.ID
	join (
		SELECT DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') as yearmonth
		from mdl_aos_canlender
		where DATE_FORMAT(DT_CANDAY,'%Y%m') > 201812
	) t
	where 1=1
	and cont.IS_DELETE = 0 and cont.S_CONTYPE = 01
	and checkstg.IS_DELETE = 0 and checkstg.S_TYPE = 3
	and checkstg.S_IFMAIN = 2 and checkstg.S_INCOMEWAY = 03
	and t.yearmonth BETWEEN DATE_FORMAT(checkstg.DT_MAINSTART,'%Y%m') and DATE_FORMAT(checkstg.DT_MAINEND,'%Y%m')
)t
left join (
	SELECT 
		S_CASECODE,
-- 		translatedict('SIGNTYPE',S_SIGNTYPE) `签约子类型`, 
		IFNULL(SUM(ass.DL_PRBILLAMT),0) `事项预开`, IFNULL(SUM(ass.DL_BACKAMT),0) `事项预回`
	from mdl_aos_sacase sacase
	left join mdl_aos_project prj on prj.I_POID = sacase.I_POID
	left join (
			SELECT I_PROID, I_PROSTAGID, a.S_NAME, DL_BACKAMT, DL_PRBILLAMT
			FROM mdl_aos_saordass a where a.I_CONID is null and a.IS_DELETE = 0
	)ass on prj.ID = ass.I_PROID
	where sacase.IS_DELETE = 0
	GROUP BY sacase.ID
)t1 on t.`事项编号` = t1.S_CASECODE

	;
