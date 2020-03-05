SELECT
a.id,
a.REAL_NAME, SUBSTR(SUBSTRING_INDEX(REAL_NAME,'-',-1) FROM 2)+0, b.s_entertime, getfullorgname(a.org_code), a.org_code,
a.*
-- COUNT(*)
from paas_aom.plf_aos_auth_user a
join paas_aom.mdl_aos_empstaff b on a.ID = b.I_USERID and b.S_YPSTATE <> 11

left join ngoss.t_sys_mnguserinfo c on a.ID = c.userid

where a.MD5_PWD is null
-- and c.userid is not null
and DATE_FORMAT(b.s_entertime,'%Y%m') = 201912
and a.org_code <> '0001001040'
ORDER BY a.org_code,SUBSTR(SUBSTRING_INDEX(REAL_NAME,'-',-1) FROM 2)+0