
SELECT c.ID as contid, c.s_concode, a.S_PRJNO, c.DL_CONAMT, c.S_CONCODE, c.S_APPSTATUS, c.S_OPERTYPE,
a.IS_DELETE, a.S_APPSTATUS, a.S_OPERTYPE
from mdl_aos_project a
left join mdl_aos_sapnotify b on a.I_PRJNOTICE = b.ID
left join mdl_aos_sacont c on b.I_POID = c.I_POID
where c.IS_DELETE = 0 and !(c.S_APPSTATUS != 1 and c.S_OPERTYPE = '001')
and s_prjno in ('YY-2018-0655-02','YY-2018-0655-02-245')
-- GROUP BY a.ID
-- HAVING COUNT(c.ID)>1