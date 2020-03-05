SELECT 
DISTINCT S_PRJNO, case S_OPERTYPE when '05' then '业务结项' when '07' then '变更中' end 'type'
from mdl_aos_project_his
where S_NAME is null
and S_OPERTYPE in ('05','07')
and DATE_FORMAT(DT_ALTERDATE,'%Y%m') = 201908
;


SELECT *
from mdl_aos_project_his
where S_OPERTYPE= '07'