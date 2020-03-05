SELECT
projectid, b.S_PRJNO projectno, 
cumulativeincome,
company, curmonincome, adjustincome, adjusttax, curmontax
-- GROUP_CONCAT(company) as companys,
-- SUM(curmonincome+adjustincome+adjusttax),
-- SUM(curmonincome+adjustincome+adjusttax+curmontax)
from t_snap_income_projectincome_final a
left join mdl_aos_project b on a.projectid = b.ID
where 1=1
and yearmonth = 201905
and (calctype != 0 or calctype is null)
and b.s_prjno = 'YY-2019-0182-93-132'
-- GROUP BY projectid