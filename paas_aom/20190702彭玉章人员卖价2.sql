SELECT 
c.*,
a.S_USERID, ngoss.getusername(S_USERID) username, I_WORKDAY `工作日天数`,
case b.S_UNITS when 1 then '人天' when 2 then '人月' end type,
S_THEIRROLE, b.S_ROLENAME, b.DL_ROLEPRICE, b.DL_AMOUNT
FROM `mdl_aos_prmember` a
left join mdl_aos_prbankunp b on a.S_THEIRROLE = b.ID and a.I_PRJID = b.I_PRJID
join (
	SELECT id, S_PRJNO, S_PRJNAME 
	from mdl_aos_project
	where IS_DELETE = 0 and S_PRJSTATUS<>'01'
) c on a.I_PRJID = c.id
where 1=1
-- and b.S_UNITS = 1
and S_THEIRROLE is not null 
-- and ngoss.getusername(S_USERID) = '刘瀚文-A7919'
-- and a.S_THEIRROLE = 1646
and b.I_PRJID = 152477
and a.S_USERID = 609339
-- and a.I_PRJID = 152709
;


SELECT
x.I_PRJID,
GROUP_CONCAT(x.`角色名称`,' 人月卖价: ',x.`角色单价`,' 数量:', x.`预计人力数量`) remark
from (
		SELECT 
		I_PRJID, 
		S_ROLENAME `角色名称`, 
		TRUNCATE(IFNULL(SUM(DL_AMOUNT),0),0) `预计人力数量`, 
		SUM(DL_ROLEPRICE) `角色单价`
		FROM `mdl_aos_prbankunp`
		where IS_DELETE = 0 
-- and S_UNITS=2
and I_PRJID = 152477
		GROUP BY I_PRJID, S_ROLENAME
)x
GROUP BY x.I_PRJID