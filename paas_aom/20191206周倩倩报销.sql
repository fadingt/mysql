SELECT S_PRJNO, S_DEPT, ID, translatedict('prjstatus',S_PRJSTATUS), S_OPERTYPE, S_APPSTATUS
from mdl_aos_project
where s_prjno like '%0028-885';


SELECT 
-- *
DISTINCT I_PRJID
from mdl_aos_prmember a
join mdl_aos_project b on a.I_PRJID = b.ID
where S_USERID = (SELECT id from plf_aos_auth_user where REAL_NAME like '周倩倩%')
-- and I_PRJID = 153220
and DATE_FORMAT(a.DT_ENDTIME,'%Y%m') >= 201911
and b.S_PRJSTATUS not in (01,06)