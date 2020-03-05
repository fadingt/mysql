-- SELECT * from plf_aos_dictionary where DICT_TYPE = 'Budgetype'

SELECT
S_BGTYEARID, id,
year(DT_PARTYEAR),
S_BUDGETDPT,
DL_TOTAMONEY `总金额`
from mdl_aos_FIBGTYEAR
where S_BUDGETYPE = 4