SELECT *
from information_schema.`COLUMNS`
where 1=1
-- and COLUMN_NAME like '%role%'
-- and COLUMN_NAME != 'S_AUTHROLE'
-- and TABLE_NAME not like 'plf_%'
-- and TABLE_NAME not like 't_snap%'
-- and TABLE_NAME != 'mdl_aos_fiprobook'
and TABLE_NAME = 'mdl_aos_project'
and TABLE_SCHEMA = 'paas_aom'
and COLUMN_NAME in (
's_prjno',
's_prjname',
'DL_BUDCOAMTI',
'OWNER_ID'
)
;
SELECT DL_BUDCOAMTI from mdl_aos_project;