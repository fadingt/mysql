-- 姓名 部门 项目 进出项目时间 卖价 项目基本信息（编号 名称 项目经理 所属部门 项目类型）
select
-- a.S_USERID,a.S_THEIRROLE, 
-- getusername(S_USERID) `姓名`,case c.S_UNITS when 1 then '人天' when 2 then '人月' end `类型`,
-- c.S_ROLENAME `卖价角色`, c.DL_ROLEPRICE `卖价`, TRUNCATE(c.DL_AMOUNT,0) `预计人力数量`,
-- a.DT_STARTTIME `进项时间`,a.DT_ENDTIME `出项时间`, I_WORKDAY `人天`, b.*
COUNT(DISTINCT b.ID)
from mdl_aos_prmember a
join (
	SELECT
	ID, S_PRJNO `项目编号`, S_PRJNAME `项目名称`
	from mdl_aos_project
	where IS_DELETE = 0 and S_PRJSTATUS <> '01' and S_PRJSTATUS <> '06' and S_PRJTYPE = 'yy'
) b on a.I_PRJID = b.ID
left join mdl_aos_prbankunp c on a.S_THEIRROLE = c.ID and a.I_PRJID = c.I_PRJID
where a.IS_DELETE = 0
and c.DL_ROLEPRICE <> 0
and a.S_THEIRROLE is not null

-- and c.S_UNITS = 1
-- limit 1000
-- GROUP BY b.ID
;
-- , ngoss.translatedict('prjclass',S_PRJCLASS) `项目类型`
-- 开发类-金额确定
-- 人力外包
-- 开发类-金额未定
-- 项目实施
-- 项目维护


	SELECT
-- c.DL_CASEMONEY `合同/事项金额`,
-- 		c.S_CASECODE, c.S_CASENAME, IFNULL(d.S_CONCODE,e.S_POCODE), null, null, null, '人月',
-- 		a.yearmonth, SUM(a.saleamt) income,'人月'
COUNT(DISTINCT b.ID)
	from t_snap_project_standardcost_detail a
	join mdl_aos_project b on a.budgetid = b.ID and b.IS_DELETE = 0
	join mdl_aos_sacase c on c.I_POID = b.I_POID
-- 	left join mdl_aos_sacont d on b.I_POID = d.I_POID
-- 	left join mdl_aos_sapoinf e on b.I_POID = e.ID
	where saleamt <> 0 and c.S_SIGNTYPE = 1
-- 	GROUP BY c.ID, c.S_CASECODE, a.yearmonth
