select
-- SUM(c.DL_ROLEPRICE*(TIMESTAMPDIFF(MONTH,a.DT_STARTTIME,a.DT_ENDTIME)+1))
a.I_PRJID, b.`项目编号`, b.`项目名称`,  prmonpl.`实际人力成本`,
getusername(S_USERID) `姓名`,case c.S_UNITS when 1 then '人天' when 2 then '人月' end `类型`,
c.S_ROLENAME `卖价角色`, c.DL_ROLEPRICE `卖价`,I_WORKDAY `人天`,
--  TRUNCATE(c.DL_AMOUNT,0) `预计人力数量`,
a.DT_STARTTIME `进项时间`,a.DT_ENDTIME `出项时间`,a.S_USERID,a.S_THEIRROLE,
-- DATEDIFF(a.DT_ENDTIME,a.DT_STARTTIME)
TIMESTAMPDIFF(MONTH,a.DT_STARTTIME,a.DT_ENDTIME)+1
from mdl_aos_prmember a
join (
	SELECT
	ID, S_PRJNO `项目编号`, S_PRJNAME `项目名称`
	from mdl_aos_project
	where IS_DELETE = 0 and S_PRJSTATUS <> '01' and S_PRJSTATUS <> '06' and S_PRJTYPE = 'yy'
) b on a.I_PRJID = b.ID
left join MDL_AOS_SAPOMONTHPR c on a.S_THEIRROLE = c.ID and a.I_PRJID = c.I_PRJID
left join (
	SELECT
	I_PRJID, SUM(DL_RLABTLFEE) `实际人力成本`
	from mdl_aos_prmonthpl
	where IS_DELETE = 0
	GROUP BY I_PRJID
)prmonpl on prmonpl.I_PRJID = a.I_PRJID
where a.IS_DELETE = 0
and c.DL_ROLEPRICE <> 0
and a.S_THEIRROLE is not null

and c.S_UNITS = 2
and a.I_PRJID = 150303
;

	SELECT
-- 	I_PRJID, SUM(DL_RLABTLFEE) `实际人力成本`
I_PRJID, S_PYEARMON, DL_RLABTLFEE, I_RLABHOUR, I_RLABTLDAY
-- *
	from mdl_aos_prmonthpl
	where IS_DELETE = 0 and I_PRJID = 150303
-- 	GROUP BY I_PRJID
;

SELECT sum(IFNULL(curmonincome,0)+IFNULL(curmontax,0)+IFNULL(adjustincome,0)+IFNULL(adjusttax,0))
from t_snap_income_projectincome_final
where projectid = 150303
;


select
SUM(c.DL_ROLEPRICE*(TIMESTAMPDIFF(MONTH,a.DT_STARTTIME,a.DT_ENDTIME)+1))
from mdl_aos_prmember a
left join MDL_AOS_SAPOMONTHPR c on a.S_THEIRROLE = c.ID and a.I_PRJID = c.I_PRJID
where a.IS_DELETE = 0
and c.DL_ROLEPRICE <> 0
and a.S_THEIRROLE is not null
and c.S_UNITS = 2
and a.I_PRJID = 150303
;
