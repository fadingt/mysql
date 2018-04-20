select * from (
select 
t.searchkey as searchkey1,
t.searchname,
t2.modulename,
t.searchsql,
getModuleLevelNames(t2.moduleid) as locahost

from t_report_unifiedsearchsql t

join t_sys_mngmoduleinfo t2 on  t.searchkey = substring_index(t2.moduleaction,'=',-1) ) xx
WHERE
 modulename like '%项目商机%'
-- searchsql like '%原%'

ORDER BY searchkey1