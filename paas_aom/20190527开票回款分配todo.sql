select
b.S_PRJNO,
	I_CONID, I_CONSTAID, I_PROID, I_PROSTAGID, I_STASTAGID, ngoss.getusername(a.OWNER_ID), a.OWNER_ID,
DL_PRBILLAMT, DL_ACBILLAMT, DL_ACBACKAMT, DL_BACKAMT,
DL_ASSAMT `已分配金额`, DL_ADBILLAMT
from mdl_aos_saordass a
left join mdl_aos_project b on a.I_PROID = b.ID
-- where a.OWNER_ID = 32073;
where I_CONSTAID is null;


SELECT SUM(DL_ACBILLAMT), SUM(DL_BACKAMT), SUM(DL_ASSAMT), SUM(DL_PRBILLAMT)
from mdl_aos_saordass
where I_PROID = (SELECT ID from mdl_aos_project where s_prjno = 'YY-2016-0140-03')
-- where I_CONID = (SELECT id from mdl_aos_sacont where S_CONCODE like 'HT-YY-2016-0140-03-1958')

-- SELECT id,I_POID from mdl_aos_sacont where S_CONCODE like 'HT-YY-2016-0140-03-1958'

SELECT 
a.S_PRJNO
from mdl_aos_project a
left join mdl_aos_sapnotify b on a.I_PRJNOTICE = b.ID
left join mdl_aos_sacont c on b.I_POID = c.I_POID
where c.S_CONCODE like 'HT-YY-2016-0140-03-1958';
;
SELECT 
SUM(DL_ASSAMT) DL_ASSAMT
from mdl_aos_saordass
where I_PROID = (SELECT ID from mdl_aos_project where s_prjno = 'YY-2016-0140-03')

SELECT
SUM(DL_ASSAMT) DL_ASSAMT, SUM(DL_ACBACKAMT) DL_ACBACKAMT, 
SUM(DL_ACBILLAMT) DL_ACBILLAMT, SUM(DL_BACKAMT) DL_BACKAMT, 
SUM(DL_PRBILLAMT) DL_PRBILLAMT, I_PROID, b.S_PRJNO
from mdl_aos_saordass a
left join mdl_aos_project b on a.I_PROID = b.ID
GROUP BY I_PROID