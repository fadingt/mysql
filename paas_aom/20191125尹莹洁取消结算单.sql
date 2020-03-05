SELECT S_STACODE, S_OPTYPE, b.DICT_NAME
from mdl_aos_sastatem a
left join plf_aos_dictionary b on a.S_APPSTATUS = b.DICT_CODE and b.DICT_TYPE = 'ApproStatus'
where S_OPTYPE = '003'