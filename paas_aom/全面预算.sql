SELECT 
a.ID `预算ID`,
S_BUDGTCODE `预算编号`,
S_BUDGTNAME `预算名称`,
CONCAT(b.dict_name,'-',d.S_GENRENAME) `预算类型`,

-- c.dict_name `预算状态`,
DL_TOTAMONEY `预算总额`,
null `预算费用`,null `预算人力`,
null `id`, null `编号`, null `名称`,
ngoss.getusername(a.OWNER_ID) `预算建立人`,
ngoss.getfullorgname(a.S_BUDGETDPT) `预算归属部门`
from MDL_AOS_FIBGTAPP a
left join (SELECT * from plf_aos_dictionary where DICT_TYPE like 'BGTAPLYTP') b on b.dict_code = a.S_BGTAPLYTP
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'TradSte') c on c.dict_code = a.S_BUDGETSTE
left join mdl_aos_fibgtcost d on a.I_BGTCOSTID = d.ID
where S_BUDGETSTE = 31 and a.IS_DELETE = 0

union all
SELECT 
	ps.ID,
	ps.s_prescode `售前编号`,
	ps.S_PRESNAME `售前名称`,
	CONCAT(psapptype.dict_name, '-', prestype.DICT_NAME) `预算类型`,
	IFNULL(ps.DL_PRESUMFEE,0) + IFNULL(ps.DL_SUMAMT,0) `总额`,
	ps.DL_PRESUMFEE `预计费用总额`,
	ps.DL_SUMAMT `预计人天总额`,
	ps.I_POID `项目商机ID`, po.S_POCODE `项目商机编号`,	po.S_PONAME `项目商机名称`,
	ngoss.getusername(ps.OWNER_ID),
	ngoss.getfullorgname(sale.ORG_CODE)
from MDL_AOS_SAPOPSAPP ps
left join mdl_aos_sapoinf po on ps.I_POID = po.ID
left join plf_aos_auth_user sale on sale.ID = ps.S_SALEMAN
left join (SELECT * from plf_aos_dictionary prestype where DICT_TYPE = 'prestype')prestype on prestype.dict_code = ps.S_PRESTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'postatus') postatus on postatus.dict_code = po.S_POSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') appstatus on appstatus.dict_code = ps.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'psapptype') psapptype on psapptype.dict_code = ps.S_OPERTYPE
where ps.S_APPSTATUS = 1 and ps.IS_DELETE = 0

union all

SELECT 
a.ID,
S_COCODE `客户商机编号`,
S_CONAME `客户商机名称`,
'客户商机' `预算类型`,
IFNULL(DL_PREFEE,0) `预算总金额`,
DL_PREFEE `预计费用金额`,
null `预算人力`,
null, null, null,
ngoss.getusername(OWNER_ID) `建立人`,
ngoss.getfullorgname(ORG_CODE) `预算归属部门`

from mdl_aos_sacoinf a
where a.S_APPSTATUS = 1 and a.IS_DELETE = 0
union all

SELECT 
d.ID, d.s_prjno `项目编号`, d.S_PRJNAME `项目名称`, '研发项目' `预算类型`,
-- DL_ALLMONEY `计划总金额`,DL_COSTMONEY `费用`, DL_MENMONEY `人力`,
d.DL_BUDTOLCOS `预算成本`, DL_BUDCOSAMT `预算费用成本`, DL_BUDLABAMT `预算人力成本`,

a.ID,S_PLANCODE `研发计划编号`,S_PLANNAME `研发计划名称`,
ngoss.getusername(a.OWNER_ID) `建立人`,
ngoss.getfullorgname(a.S_DEPT) `预算归属部门`
from mdl_aos_prplan a
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'FPoperation') b on b.dict_code = a.s_opertype
left join mdl_aos_prpstage c on c.I_PLANID = a.ID
left join mdl_aos_project d on d.I_PRPSID = c.ID
where 1=1
	and a.S_APPSTATUS = 1 and a.IS_DELETE = 0
	and d.ID is not null and d.IS_DELETE = 0 and d.S_APPSTATUS = 1
