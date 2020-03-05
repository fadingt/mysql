-- 3.固定金额
-- 一次性02： 计划金额 验收报告日期 是否验收
-- 按月均摊03： 维保期内均摊 开始日期 结束日期 计划金额 是否维保
SELECT 
checkstg.S_IFCHECK, translatedict('incomeway',checkstg.S_INCOMEWAY), 
checkstg.DL_CHECKAMT `验收金额`, checkstg.DL_CHECKRATE, checkstg.DT_CHECKDATE `实际验收日期`, 
DATE_FORMAT(checkstg.DT_CHECKDATE,'%Y%m') yearmonth,
cont.S_CONCODE, cont.S_CONNAME
from mdl_aos_sacont cont
left join mdl_aos_sacheckapp checkapp on checkapp.I_CONID = cont.ID
left join mdl_aos_sacheckstg checkstg on checkstg.I_CKID = checkapp.ID
where 1=1
and cont.IS_DELETE = 0 and cont.S_CONTYPE = 01
and checkstg.IS_DELETE = 0 and checkstg.S_TYPE = 3
and checkstg.S_IFCHECK = 2 and checkstg.S_INCOMEWAY = 02
