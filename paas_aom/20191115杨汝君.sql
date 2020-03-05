SELECT 
-- *
S_PRJNO, CREATE_TIME, DT_ALTERDATE, S_NAME, T_PRJDESC, 
ngoss.translatedict('prjstatus',S_PRJSTATUS), ngoss.translatedict('opertype',S_OPERTYPE),
ngoss.translatedict('ApproStatus',S_APPSTATUS),
 DL_BUDCOAMTI,  T_REASON
from mdl_aos_project_his
where S_PRJNO like 'YY-2018-0665-17'