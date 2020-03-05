SELECT
	  I_CUSTID `客户ID`, ngoss.getcustname(I_CUSTID) `客户名称`, S_DEPTL `部门条线`, getusername(S_TECHID) `客户经理`
from mdl_aos_sacusttech
where IS_DELETE = 0
ORDER BY I_CUSTID, S_DEPTL, S_TECHID