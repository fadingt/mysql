SELECT REAL_NAME, ACCOUNT_ID, ACCOUNT_PWD, MD5_PWD, ID, getfullorgname(ORG_CODE)
from plf_aos_auth_user
where REAL_NAME like '%刘兴宇%'
-- where id = 614287
-- where ACCOUNT_ID = 'a3909'
;

-- d93a5def7511da3d0f2d171d9c344e91 123456
-- 21218cca77804d2ba1922c33e0151105 888888 46cc468df60c961d8da2326337c7aa58
-- 1da390d3baecdfabab7bc1f145594965 agree123

SELECT MD5('21218cca77804d2ba1922c33e0151105');


SELECT S_ENTERTIME
from mdl_aos_empstaff
where S_NAME like '刘宁-A4865'