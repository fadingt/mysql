SELECT 
-- DL_AMOUNT,
I_PRJID, b.S_PRJNO,
DL_AMOUNT `预计人力数量`,
a.S_NAME `员工姓名`,
DL_ROLEPRICE `角色单价`,
S_ROLENAME `角色名称`,
case S_UNITS when 1 then '人*天' when 2 then '人*月' END `单位`
from mdl_aos_prbankunp a
left join mdl_aos_project b on a.I_PRJID = b.ID
where a.IS_DELETE = 0
and a.S_UNITS = 2
;


SELECT
projectid, projectno, GROUP_CONCAT(company) as companys,
SUM(curmonincome+adjustincome+adjusttax),
SUM(curmonincome+adjustincome+adjusttax+curmontax)
from t_snap_income_projectincome_final
where 1=1
and yearmonth = 201905
and (calctype != 0 or calctype is null)
GROUP BY projectid
;


SELECT S_PRJNO
from mdl_aos_project
where 1=1
and IS_DELETE=0 and !(S_OPERTYPE = 001 and S_APPSTATUS <>1)
and id not in (
SELECT DISTINCT I_PROJECTID
from mdl_aos_PRITOWORK
where S_YEARMONTH = '2019-05'
)
;

SELECT projectno, projectid
from t_snap_income_projectincome_final
where 1=1
and (calctype !=0 or calctype is null)
and yearmonth = 201905
and projectid not in (
SELECT DISTINCT I_PROJECTID
from mdl_aos_PRITOWORK
where S_YEARMONTH = '2019-05'
)