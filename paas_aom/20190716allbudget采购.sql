SELECT s_prjno, ID, DL_BUDPURAMT, DL_BUDCOSAMT, DL_BUDLABAMT, DL_CRYORPUR
from paas_aom.mdl_aos_project
where DL_BUDPURAMT <> 0
and IS_DELETE = 0 and S_PRJSTATUS<>'01'
-- and DL_CRYORPUR <> 0
and S_PRJNO like 'YY-2019-0014-0001-446';


SELECT debit, credit, budgetno, busino, busitypename, busitype, mxno, zzno, mxname
from t_snap_fi_voucher
where 1=1
and budgetno like 'YY-2019-0014-0001-446'
-- and budgetno not in (
-- SELECT s_prjno
-- from paas_aom.mdl_aos_project
-- where DL_BUDPURAMT <> 0
-- and IS_DELETE = 0 and S_PRJSTATUS<>'01'
-- )
and mxno in (140501,140502,14050333,14050334,600101,600102,640133,640134)
and dc='01'
;

SELECT DL_STOCKAMT, I_MATERIAL, DL_INSUMAMT
from mdl_aos_prpurchas
where I_PRJID = 152735;

SELECT * 
FROM `mdl_aos_pumatter`
where id = 1589152054;

SELECT *
from MDL_AOS_PURREQ
where S_BUDGTCODE = 152735