SELECT *
from mdl_aos_sapoinf
where 1=1
-- and LOCATE(31629, DATA_SHARING) != 0
and OWNER_ID = 31629
;

SELECT a.id, a.S_CUSTNAME, b.S_TECHID, c.REAL_NAME, b.S_DEPTL
from mdl_aos_sacustinf a
left join mdl_aos_sacusttech b on a.ID = b.I_CUSTID
left join plf_aos_auth_user c on b.S_TECHID = c.ID
where 1=1
-- and S_CUSTNAME like '%三湘银行%'
and a.ID = 410
and S_TECHID = 31944
-- 31522,31519,609384,

-- 74	长沙银行股份有限公司
-- 217	湖南省农村信用社联合社
-- 375	华融湘江银行股份有限公司
-- 4571	三湘银行股份有限公司



SELECT S_POCODE, OWNER_ID, DATA_SHARING, S_APPSTATUS, S_POSTAGE, I_CUSTID
from mdl_aos_sapoinf
where 1=1
and s_pocode like 'YY-2018-0615-09'
-- and I_CUSTID = 3023
-- and i_custid in (74, 217, 375, 4571)
-- and OWNER_ID != 31629