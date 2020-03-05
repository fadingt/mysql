SELECT
projectid, yearmonth,
SUM(curmonincome+adjustincome+adjusttax) `收入(不含税)`, 
SUM(curmontax) `税额`,
SUM(curmonincome+adjustincome+adjusttax+curmontax) `收入`
from t_snap_income_projectincome_final
where 1=1
and yearmonth > 201812
and (calctype != 0 or calctype is NULL)
GROUP BY projectid, yearmonth