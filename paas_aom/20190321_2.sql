SELECT
a.I_PROTNAME,c.s_concode, c.S_CONNAME,		a.S_STACODE,a.S_STANAME, b.S_STAGEDES,
-- ApproStatus.dict_name,
b.I_BILLID, b.I_BOUNCEID,DL_ACBILLAMT, DL_BILLAMT
from mdl_aos_sastatem a
left join mdl_aos_saorderst b on a.ID = b.I_STATEID
left join mdl_aos_sacont c on a.I_PROTNAME = c.ID
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'ApproStatus')ApproStatus on ApproStatus.dict_code = a.S_APPSTATUS

where 1=1
and b.I_BILLID is not null
and a.IS_DELETE = 0 and b.IS_DELETE = 0

union all

SELECT
a.ID as conid, a.S_CONCODE, a.s_conname,		b.ID, null, b.S_STAGEDES,
-- ApproStatusb.dict_name,
b.I_BILLID, b.I_BOUNCEID,
b.DL_ACBILLAMT, b.DL_BILLAMT
from mdl_aos_sacont a
left join mdl_aos_saconstag b on b.I_CONID = a.ID
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'ApproStatus')ApproStatusb on ApproStatusb.dict_code = b.S_APPSTATUS
where b.I_BILLID is not null
and a.IS_DELETE = 0 and b.IS_DELETE = 0