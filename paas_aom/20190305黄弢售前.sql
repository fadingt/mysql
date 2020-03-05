SELECT 
-- 	psdtl.S_PRESOWNER `售前负责人`, ps.S_SALEMAN `销售代表`, psdtl.S_PRESELLER `售前人员`,
	DATE_FORMAT(ps.DT_YEAR,'%Y') `所属年份`,
	ps.ID,
	ps.I_POID `项目商机ID`,
	po.S_POCODE `项目商机编号`,
	po.S_PONAME `项目商机名称`,
	postatus.dict_name `项目商机状态`,
	ps.s_prescode `售前编号`,
	ps.S_PRESNAME `售前名称`,
	appstatus.dict_name `审批状态`,
	psapptype.dict_name `操作类型`,
	ps.S_CUSTNAME `客户名称`,

	tec1.REAL_NAME `客户经理A`, tec2.REAL_NAME `客户经理B`, tec1dept1.ORG_TREE `客户经理A所属部门`, tec1dept2.ORG_TREE `客户经理B所属部门`,
	sale.REAL_NAME `销售代表`,
-- 	saleorg.ORG_TREE `销售所属部门`,
	prestype.dict_name `售前分类`,
	ps.I_CITYID `售前城市`,
	ps.DL_PRESUMFEE `预计费用总额`,
	ps.DL_OCCFEE `预算费用已使用额`,
	ps.DL_AVAILFEE `可用费用总额`,
	ps.DL_FREEFEE `释放费用总额`,
	ps.DL_SUMAMT `预计人天总额`,
-- 	psdtl.DL_PREFEEAMT xxxxxxxx,
	ps.DL_OCCAMT `占用人天总额`,
	ps.DL_USEDAMT `已使用人天金额`,
	ps.DL_SUMDAYS `预计人天总数`,
	DATE_FORMAT(DT_BEGDATE,'%Y-%m-%d') `开始日期`, DATE_FORMAT(DT_ENDDATE,'%Y-%m-%d') `结束日期`,
	DATE_FORMAT(ps.CREATE_TIME,'%Y-%m-%d') `创建日期`,
	DATEDIFF(ps.DT_BEGDATE,ps.CREATE_TIME) diff

from MDL_AOS_SAPOPSAPP ps
left join mdl_aos_sapoinf po on ps.I_POID = po.ID
left join mdl_aos_sacustinf cust on cust.ID = po.I_CUSTID
left join plf_aos_auth_user tec1 on tec1.ID = cust.S_FIRTECH
left join (
		SELECT 
			case LENGTH(a.S_ORGCODE)
			when 10 then a.S_NAME
			when 13 then CONCAT(b.S_NAME,'-',a.S_NAME)
			when 16 then CONCAT(c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			end as ORG_TREE, a.S_ORGCODE
		FROM `mdl_aos_hrorg` a
		join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from mdl_aos_hrorg) b on a.S_PORGCODE = b.S_ORGCODE
		join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from mdl_aos_hrorg) c on b.S_PORGCODE = c.S_ORGCODE
)tec1dept1 on tec1dept1.S_ORGCODE = tec1.ORG_CODE
left join plf_aos_auth_user tec2 on tec2.ID = cust.S_SECTECH
left join (
		SELECT 
			case LENGTH(a.S_ORGCODE)
			when 10 then a.S_NAME
			when 13 then CONCAT(b.S_NAME,'-',a.S_NAME)
			when 16 then CONCAT(c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			end as ORG_TREE, a.S_ORGCODE
		FROM `mdl_aos_hrorg` a
		join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from mdl_aos_hrorg) b on a.S_PORGCODE = b.S_ORGCODE
		join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from mdl_aos_hrorg) c on b.S_PORGCODE = c.S_ORGCODE
) tec1dept2 on tec1dept2.S_ORGCODE = tec2.ORG_CODE

left join (SELECT * from plf_aos_dictionary prestype where DICT_TYPE = 'prestype')prestype on prestype.dict_code = ps.S_PRESTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'postatus') postatus on postatus.dict_code = po.S_POSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') appstatus on appstatus.dict_code = ps.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'psapptype') psapptype on psapptype.dict_code = ps.S_OPERTYPE

left join plf_aos_auth_user sale on sale.ID = ps.S_SALEMAN
left join (
		SELECT 
			case LENGTH(a.S_ORGCODE)
			when 10 then a.S_NAME
			when 13 then CONCAT(b.S_NAME,'-',a.S_NAME)
			when 16 then CONCAT(c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			end as ORG_TREE, a.S_ORGCODE
		FROM `mdl_aos_hrorg` a
		join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from mdl_aos_hrorg) b on a.S_PORGCODE = b.S_ORGCODE
		join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from mdl_aos_hrorg) c on b.S_PORGCODE = c.S_ORGCODE
) saleorg on saleorg.S_ORGCODE = sale.ORG_CODE
-- left join MDL_AOS_SAPOPSDTL psdtl on ps.ID = psdtl.I_PRESALEID
-- GROUP BY ps.ID
-- HAVING COUNT(psdtl.id) > 1
/*
序号/年份/售前编号/售前名称/客户名称/所属项目商机名称/所属项目商机编号/所属项目商机状态/售前分类/售前城市/预计费用总额/
预算费用已使用额/预计人天总额/预计人天总数/预计人工已使用额/实际人天/开始时间/结束时间
/申请人/生效状态/售前分类/创建时间/最后修改时间

SELECT 
-- S_PRESELLER
-- S_DEPTNAME
COUNT(DISTINCT S_DEPTNAME),
GROUP_CONCAT(DISTINCT b.S_NAME),
GROUP_CONCAT(DISTINCT S_DEPTNAME)
from MDL_AOS_SAPOPSDTL a
left join mdl_aos_hrorg b on a.S_DEPTNAME = b.S_ORGCODE
GROUP BY I_PRESALEID
HAVING COUNT(DISTINCT S_DEPTNAME) >1
*/