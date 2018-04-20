SELECT
fi.deptid,
p.deptid,
deptname,
SUM(d_income),
left(fi.yearmonth,4)
FROM
(
	SELECT projectid, deptid, getunitname(deptid) deptname ,(curmonincome+adjustincome+taxfreeincome) d_income, yearmonth
	from t_income_prjmonthincome_fi
) fi
left join
(
	SELECT projectid, deptid
	from t_project_projectinfo
) p on p.projectid = fi.projectid and p.deptid = fi.deptid
GROUP BY fi.deptid, left(fi.yearmonth,4)
;

-- SELECT unitid from t_sys_mngunitinfo WHERE unitname like '运营管理部'
-- SELECT unitid, unitname, isdel from t_sys_mngunitinfo WHERE unitid in (30884,30887,30890)