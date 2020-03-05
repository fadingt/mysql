SELECT 
 DISTINCT I_PROID, I_CONID, cont.S_CONCODE, p.S_PRJNO, cont.IS_DELETE, cont.S_APPSTATUS
from mdl_aos_saordass a
left join mdl_aos_sacont cont on cont.id = I_CONID
left join mdl_aos_project p on p.id = I_PROID
where I_PROID = 152557;

SELECT 
 I_PROID, I_CONID
from mdl_aos_saordass
GROUP BY I_CONID
HAVING COUNT(DISTINCT I_PROID) >1
;

SELECT 
 I_PROID, I_CONID, b.S_CONCODE
from mdl_aos_saordass a
left join mdl_aos_sacont b on a.I_CONID = b.ID
-- where I_PROID = 152557
GROUP BY I_PROID
HAVING COUNT(DISTINCT I_CONID) >1