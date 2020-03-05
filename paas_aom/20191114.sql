SELECT 
S_STACODE, S_STANAME, 
(SELECT real_name from plf_aos_auth_user where id = OWNER_ID) `销售代表`,
case S_STATYPE when 1 then '实际' when 0 then '预计' END `结算单类型`,
case S_APPSTATUS when 3 then '待审核' when 4 then '起草中' END `审批状态`,
case S_ASSSTA when 1 then '已分配' when 0 then '未分配' END `分配状态`,
S_OPTYPE
from mdl_aos_sastatem
where S_APPSTATUS in (3,4)
and IS_DELETE = 0
-- and S_STATYPE = 1
ORDER BY ID