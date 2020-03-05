-- 1框架协议：
-- 一次性02： 计划金额 验收报告日期 是否验收
-- 按月均摊03： 维保期内均摊 开始日期 结束日期 计划金额 是否维保
SELECT 
t.yearmonth,
12*(year(DT_MAINEND)-year(DT_MAINSTART)) + month(DT_MAINEND)-month(DT_MAINSTART)+1 `维保期`,
sacase.S_CASECODE, checkstg.DT_MAINSTART, checkstg.DT_MAINEND,
translatedict('incomeway',checkstg.S_INCOMEWAY) `收入确认方式`,
checkstg.DT_CHECKDATE `实际验收日期`,
checkstg.DL_CHECKAMT `验收阶段金额`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = sacase.S_SIGNTYPE and DICT_TYPE = 'signType') `签约子类型`,
cont.S_CONCODE, cont.S_CONNAME
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
ORDER BY S_CASECODE, t.yearmonth