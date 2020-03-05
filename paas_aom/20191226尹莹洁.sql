SELECT
cont.S_CONCODE, cont.S_CONNAME, cont.I_CUSTID,
o.S_STACODE, o.S_STANAME, ost.ID, ost.DL_ACBILLAMT, ost.DL_BILLAMT,ost.DL_BACKAMT,
ost.DL_ACBACKAMT
from mdl_aos_sacont cont
left join mdl_aos_sastatem o on cont.id = o.I_PROTNAME
left join mdl_aos_saorderst ost on ost.I_STATEID = o.ID
where 1=1
and o.S_STACODE = 'JSD-00000760'
-- and o.S_STACODE = 'JSD-00000554'
-- and I_CUSTID = 326
and o.IS_DELETE = 0 and ost.IS_DELETE = 0
-- and o.S_ASSSTA <> 1
-- and ost.DL_ACBACKAMT <> 0