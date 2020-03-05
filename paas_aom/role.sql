SELECT *
from plf_aos_module
where id = 315;


SELECT *
from plf_aos_auth_permission
where PERM_DESC like '/report?searchkey=%'
-- 3554
;
SELECT *
from plf_aos_role_permission
where PERMISSION_ID = 3554;


SELECT *
from plf_aos_auth_role
where id = 56