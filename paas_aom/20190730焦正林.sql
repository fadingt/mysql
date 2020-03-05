-- 姓名 部门 项目 进出项目时间 卖价 项目基本信息（编号 名称 项目经理 所属部门 项目类型）
select
a.S_USERID,a.S_THEIRROLE, 
case a.IS_DELETE when 0 then '未删除' when 1 then '已删除' end `是否删除`,
ngoss.getusername(S_USERID) `姓名`,case c.S_UNITS when 1 then '人天' when 2 then '人月' end `类型`,
c.S_ROLENAME `卖价角色`, c.DL_ROLEPRICE `卖价`, TRUNCATE(c.DL_AMOUNT,0) `预计人力数量`,
a.DT_STARTTIME `进项时间`,a.DT_ENDTIME `出项时间`, I_WORKDAY `人天`,
b.*
from mdl_aos_prmember a
join (
	SELECT
	ID, S_PRJNO `项目编号`, S_PRJNAME `项目名称`, ngoss.getusername(S_MANAGER) `项目经理`,
	ngoss.getfullorgname(S_DEPT) `项目所属部门`, ngoss.translatedict('prjclass',S_PRJCLASS) `项目类型`
	from mdl_aos_project
	where IS_DELETE = 0 and S_PRJSTATUS <> '01' and S_PRJTYPE = 'yy'
) b on a.I_PRJID = b.ID
left join mdl_aos_prbankunp c on a.S_THEIRROLE = c.ID and a.I_PRJID = c.I_PRJID
where a.S_THEIRROLE is not null
-- and c.id is null