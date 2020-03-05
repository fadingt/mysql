SELECT
	SUBSTRING_INDEX(a.username,'-',1), a.usercode, a.`password`,
	b.unitlist, b.remark4
from t_sys_mnguserinfo a, t_sys_mngunitinfo b
where userid >= 609980 and a.deptid = b.unitid