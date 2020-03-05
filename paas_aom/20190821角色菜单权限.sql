SELECT DISTINCT PERM_NAME 
FROM `plf_aos_auth_permission`
where id in (
SELECT PERMISSION_ID
FROM `plf_aos_role_permission`
where ROLE_ID = 41
and IS_DELETE = 0
)
and BIZ_TYPE = 'MENU';


SELECT REAL_NAME, ROLE_IDS
from plf_aos_auth_user
where REAL_NAME like '王向营%';


SELECT *
from plf_aos_auth_role
where id in (34,56)