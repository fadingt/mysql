-- SELECT 
-- *
-- -- DICT_CODE
-- from plf_aos_dictionary
-- where DICT_TYPE like 'STAFFJOB' 
-- and dict_name like '%管理%' and DICT_NAME not like '职能管理%'
-- 
SELECT S_STAFFJOB, s_name, S_AUTHROLE
FROM mdl_aos_empstaff
where 1=1
and S_AUTHROLE =2
and s_staffjob not 
-- = '04'
in (SELECT 
DICT_CODE
from plf_aos_dictionary
where DICT_TYPE like 'STAFFJOB' 
and SUBSTRING_INDEX(dict_name,'-',-1) like '%管%'
)
-- and S_NAME like '%A0955'