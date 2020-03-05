

SELECT
cont.S_CONCODE `合同/事项编号`, cont.S_CONNAME `合同/事项名称`, '固定金额' `合同类型`, null `框架合同编号`, getusername(poinf.OWNER_ID) `客户经理`,
DATE_FORMAT(cont.DT_FILEDATE,'%Y-%m-%d') `合同归档日期`,
checkstg.*
from mdl_aos_sacont cont
left join mdl_aos_sapoinf poinf on cont.I_POID = poinf.ID
left join (
	SELECT
		checkstg.I_POID as i_otherid,
		translatedict('checkstg',checkstg.S_STGNAME) `验收阶段名称`,
		DATE_FORMAT(checkstg.DT_CHECKTIME,'%Y-%m-%d')`预计验收日期`,
		checkstg.DL_CHECKAMT `预计验收金额`,
		checkstg.DL_CHECKRATE `验收占比`,
		DATE_FORMAT(checkstg.DT_CHECKDATE,'%Y-%m-%d') `实际验收日期`,
		case checkstg.S_IFCHECK when 1 then '否' when 2 then '是' END `是否验收`,
		case checkstg.S_IFMAIN when 1 then '否' when 2 then '是' END `是否维保`,
		DATE_FORMAT(checkstg.DT_MAINSTART,'%Y-%m-%d') `维保开始日期`,
		DATE_FORMAT(checkstg.DT_MAINEND,'%Y-%m-%d') `维保结束日期`,
		translatedict('incomeway', checkstg.S_INCOMEWAY) `收入确认方式`
	from mdl_aos_sacheckstg checkstg
	where checkstg.IS_DELETE = 0 and checkstg.S_TYPE = 1
)checkstg on checkstg.i_otherid = cont.I_POID
where cont.IS_DELETE = 0 and cont.S_CONTYPE = 1

union all

SELECT
sacase.S_CASECODE, sacase.S_CASENAME, '框架协议', cont.S_CONCODE, getusername(poinf.OWNER_ID),
DATE_FORMAT(cont.DT_FILEDATE,'%Y-%m-%d') `合同归档日期`,
checkstg.*
from mdl_aos_sacont cont
left join mdl_aos_sacase sacase on sacase.I_POID = cont.I_POID
left join mdl_aos_sapoinf poinf on poinf.ID = cont.I_POID
left join (
	SELECT
		checkstg.I_CASEID as i_otherid,
		translatedict('checkstg',checkstg.S_STGNAME) `验收阶段名称`,
		DATE_FORMAT(checkstg.DT_CHECKTIME,'%Y-%m-%d')`预计验收日期`,
		checkstg.DL_CHECKAMT `预计验收金额`,
		checkstg.DL_CHECKRATE `验收占比`,
		DATE_FORMAT(checkstg.DT_CHECKDATE,'%Y-%m-%d') `实际验收日期`,
		case checkstg.S_IFCHECK when 1 then '否' when 2 then '是' END `是否验收`,
		case checkstg.S_IFMAIN when 1 then '否' when 2 then '是' END `是否维保`,
		DATE_FORMAT(checkstg.DT_MAINSTART,'%Y-%m-%d') `维保开始日期`,
		DATE_FORMAT(checkstg.DT_MAINEND,'%Y-%m-%d') `维保结束日期`,
		translatedict('incomeway', checkstg.S_INCOMEWAY) `收入确认方式`
	from mdl_aos_sacheckstg checkstg
	where checkstg.IS_DELETE = 0 and checkstg.S_TYPE = 2
)checkstg on checkstg.i_otherid = sacase.ID
where cont.IS_DELETE = 0 and cont.S_CONTYPE = 2 and sacase.IS_DELETE = 0