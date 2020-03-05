SELECT 
p.S_PRJNO `项目编号`,
p.S_PRJNAME `项目名称`,
org2.s_name `一级部门`,
org1.s_name `二级部门`,
case LENGTH(p.s_dept) when 16 then CONCAT(org2.s_name,'-',org1.s_name,'-',org.s_name) else CONCAT(org2.s_name,'-',org1.s_name) end `项目所属部门`,
prjclass.DICT_NAME `项目分类`,
-- cont.contype `项目类型`,
prjstatus.DICT_NAME `项目状态`,
ApproStatus.DICT_NAME `审批状态`,
opertype.DICT_NAME `操作类型`,
PBaseType.DICT_NAME `依据状态`,
incomeway.DICT_NAME `收入确认方式`,
pm.REAL_NAME `项目经理`,
pd.REAL_NAME `项目总监`,
cust.S_CUSTNAME `客户名称`,

sale.REAL_NAME `销售代表`,
saleorg.S_NAME `销售部门`,
case when LENGTH(saleorg.S_ORGCODE) > 13 then (SELECT left(S_NAME,2) from mdl_aos_hrorg where ID = saleorg.S_PRE_ORG) else saleorg.S_NAME end `销售大区`,
tech1.REAL_NAME `客户经理a`,
tech2.REAL_NAME `客户经理b`,
DT_SETUPTIME `项目创建日期`,
p.DT_STARTTIME `项目开始日期`,
p.DT_ENDTIME `项目结束日期`,
p.DT_MAINEND  `项目维保期`,
p.DL_BUDCOAMTI `立项金额`,
p.DL_BUDTOLCOS `预算总成本`,
p.DL_BUDLABAMT `预算人力成本`,
p.DL_BUDPURAMT `预算采购成本`,
p.DL_BUDCOSAMT `预算费用成本`

from mdl_aos_project p
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjclass') prjclass on prjclass.DICT_CODE = p.S_PRJCLASS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjstatus') prjstatus on prjstatus.DICT_CODE = p.S_PRJSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.DICT_CODE = p.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'OPERTYPE') opertype on opertype.DICT_CODE = p.S_OPERTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'PBaseType') PBaseType on PBaseType.DICT_CODE = p.S_BASEFULL
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'INCOMEWAY') incomeway on incomeway.DICT_CODE = p.S_INCOMEWAY
-- left join mdl_aos_project b on LOCATE(CONCAT(',',b.ID),S_PRIDS) != 0

left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
left join plf_aos_auth_user pd on pd.ID = p.S_DIRECTOR
left join mdl_aos_hrorg org on org.S_ORGCODE = p.S_DEPT
left join mdl_aos_hrorg org1 on org1.s_orgcode = left(p.s_dept,13)
left join mdl_aos_hrorg org2 on org2.s_orgcode = left(p.s_dept,10)

left join mdl_aos_sapnotify nify on nify.ID = p.I_PRJNOTICE
left join mdl_aos_sapoinf buz on buz.ID = nify.I_POID
left join mdl_aos_sacustinf cust on cust.ID = buz.I_CUSTID
left join plf_aos_auth_user tech1 on tech1.ID = cust.S_FIRTECH
left join plf_aos_auth_user tech2 on tech2.ID = cust.S_SECTECH
left join plf_aos_auth_user sale on sale.ID = cust.S_SALEOWNER
left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = sale.ORG_CODE
join (
	SELECT * from plf_aos_auth_org 
	where org_code = '0001001027'
)tec1org on tec1org.org_code = left(tech1.org_code,10)

WHERE	
	p.IS_DELETE = 0  AND p.S_PRJTYPE = 'YY'  AND p.S_PRJSTATUS <> '01'

union all

SELECT 
p.S_PRJNO `项目编号`,
p.S_PRJNAME `项目名称`,
org2.org_name `一级部门`,
org1.s_name `二级部门`,
case LENGTH(p.s_dept) when 16 then CONCAT(org2.org_name,'-',org1.s_name,'-',org.s_name) else CONCAT(org2.org_name,'-',org1.s_name) end `项目所属部门`,
prjclass.DICT_NAME `项目分类`,
-- cont.contype `项目类型`,
prjstatus.DICT_NAME `项目状态`,
ApproStatus.DICT_NAME `审批状态`,
opertype.DICT_NAME `操作类型`,
PBaseType.DICT_NAME `依据状态`,
incomeway.DICT_NAME `收入确认方式`,
pm.REAL_NAME `项目经理`,
pd.REAL_NAME `项目总监`,
cust.S_CUSTNAME `客户名称`,

sale.REAL_NAME `销售代表`,
saleorg.S_NAME `销售部门`,
case when LENGTH(saleorg.S_ORGCODE) > 13 then (SELECT left(S_NAME,2) from mdl_aos_hrorg where ID = saleorg.S_PRE_ORG) else saleorg.S_NAME end `销售大区`,
tech1.REAL_NAME `客户经理a`,
tech2.REAL_NAME `客户经理b`,
DT_SETUPTIME `项目创建日期`,
p.DT_STARTTIME `项目开始日期`,
p.DT_ENDTIME `项目结束日期`,
p.DT_MAINEND  `项目维保期`,
p.DL_BUDCOAMTI `立项金额`,
p.DL_BUDTOLCOS `预算总成本`,
p.DL_BUDLABAMT `预算人力成本`,
p.DL_BUDPURAMT `预算采购成本`,
p.DL_BUDCOSAMT `预算费用成本`


from mdl_aos_project p
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjclass') prjclass on prjclass.DICT_CODE = p.S_PRJCLASS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjstatus') prjstatus on prjstatus.DICT_CODE = p.S_PRJSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.DICT_CODE = p.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'OPERTYPE') opertype on opertype.DICT_CODE = p.S_OPERTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'PBaseType') PBaseType on PBaseType.DICT_CODE = p.S_BASEFULL
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'INCOMEWAY') incomeway on incomeway.DICT_CODE = p.S_INCOMEWAY
-- left join mdl_aos_project b on LOCATE(CONCAT(',',b.ID),S_PRIDS) != 0

left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
left join plf_aos_auth_user pd on pd.ID = p.S_DIRECTOR
left join mdl_aos_hrorg org on org.S_ORGCODE = p.S_DEPT
left join mdl_aos_hrorg org1 on org1.s_orgcode = left(p.s_dept,13)
join (SELECT * from plf_aos_auth_org where org_code = '0001001027') org2 on org2.org_code = left(p.s_dept,10)

left join mdl_aos_sapnotify nify on nify.ID = p.I_PRJNOTICE
left join mdl_aos_sapoinf buz on buz.ID = nify.I_POID
left join mdl_aos_sacustinf cust on cust.ID = buz.I_CUSTID
left join plf_aos_auth_user tech1 on tech1.ID = cust.S_FIRTECH
left join plf_aos_auth_user tech2 on tech2.ID = cust.S_SECTECH
left join plf_aos_auth_user sale on sale.ID = cust.S_SALEOWNER
left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = sale.ORG_CODE

WHERE	
	p.IS_DELETE = 0  AND p.S_PRJTYPE = 'YF' AND p.S_PRJSTATUS <> '01'