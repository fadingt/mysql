select 
t.searchkey,
t.searchname,
t2.modulename,
-- t.searchsql,
getModuleLevelNames(t2.moduleid) as locahost

from t_report_unifiedsearchsql t

join t_sys_mngmoduleinfo t2 on  t.searchkey = substring_index(t2.moduleaction,'=',-1)
WHERE 1=1
and modulename like '%其他项目%'
-- and searchkey like '%self_loan2%'
-- and searchsql like '%t_budget_paymentbill%'
-- and searchsql like '%chown%'
ORDER BY searchkey