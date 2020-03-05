SELECT 
c.*,
a.S_USERID, ngoss.getusername(S_USERID) `员工姓名`, 
-- I_WORKDAY `工作日天数`,
case b.S_UNITS when 1 then '人天' when 2 then '人月' end `类型`,
S_THEIRROLE, b.S_ROLENAME `卖价角色`, b.DL_ROLEPRICE `卖价`, IFNULL(TRUNCATE(b.DL_AMOUNT,0),0) `预计人力数量`
FROM `mdl_aos_prmember` a
left join mdl_aos_prbankunp b on a.S_THEIRROLE = b.ID and a.I_PRJID = b.I_PRJID
join (
	SELECT id, S_PRJNO `项目编号`, S_PRJNAME `项目名称`,
-- ngoss.translatedict('prjclass',s_prjclass) `项目类型`
	from mdl_aos_project
	where IS_DELETE = 0 and S_PRJSTATUS<>'01'
) c on a.I_PRJID = c.id
where S_THEIRROLE is not null
-- and c.`项目类型` != '人力外包'