SELECT
DT_CHECKDATE, DT_CHECKTIME, DL_CHECKRATE, DL_CHECKAMT `计划金额`, S_STGNAME,
case S_IFMAIN when 1 then '否' when 2 then '是' END `是否维保`,
S_IFCHECK `是否验收`,
translatedict('incomeway',S_INCOMEWAY) `收入确认方式`,
DT_CHECKDATE `实际验收时间`
-- DISTINCT S_INCOMEWAY
from mdl_aos_sacheckstg a
left join mdl_aos_sacase b on a.I_CASEID = b.ID

where S_TYPE = 2


-- 商机	1	ckstgtype
-- 事项	2	ckstgtype
-- 验收报告	3	ckstgtype

-- 
-- 成本百分比	01
-- 一次性	02
-- 按月均摊	03
-- 按人月	04