SELECT
a.I_CUSTID `客户ID`,
ngoss.getcustname(a.I_CUSTID) `客户`,
S_DEPTL `条线`,
tec.REAL_NAME `客户经理`,
tecarea.s_name `客户经理区域`,
b.I_RANK `级别`
from mdl_aos_sacusttech a
left join (
	SELECT S_JOBLEVEL, I_USERID, c.I_RANK
	from mdl_aos_empstaff a, mdl_aos_rank c
	where a.IS_DELETE = 0 and c.IS_DELETE = 0 and a.S_JOBLEVEL = c.ID and a.S_YPSTATE <> 11
) b on a.S_TECHID = b.I_USERID
left join plf_aos_auth_user tec on a.S_TECHID = tec.ID
left join mdl_aos_hrorg tecarea on tecarea.S_ORGCODE = left(tec.org_code,13)
ORDER BY a.I_CUSTID, a.S_DEPTL, a.S_TECHID
