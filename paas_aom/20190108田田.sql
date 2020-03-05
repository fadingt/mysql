set @a := (SELECT PW_VALID_DATE
from plf_aos_auth_user
where IS_DELETE = 0
and ACCOUNT_ID = 'a11156');


set @b := (SELECT CREATE_TIME
from mdl_aos_empstaff
where S_NAME like '%a11156')
;

SELECT DATEDIFF(@a,@b)