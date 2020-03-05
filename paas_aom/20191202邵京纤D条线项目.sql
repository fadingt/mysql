SELECT 
p.S_PRJNO `项目编号`,
p.S_PRJNAME `项目名称`,
-- ngoss.getfullorgname(p.s_dept) `项目所属部门`,
case LENGTH(p.S_DEPT) when 10 then org1.S_NAME when 13 then CONCAT(org1.S_NAME,'-',org2.S_NAME)
when 16 then CONCAT(org1.S_NAME,'-',org2.S_NAME,'-',org3.S_NAME) END `项目所属部门`,
case LENGTH(p.S_DEPT) when 10 then org1.S_NAME when 13 then CONCAT(org1.S_NAME,'-',org2.S_NAME)
when 16 then CONCAT(org1.S_NAME,'-',org2.S_NAME) END `新归属部门`,
p.S_DEPT `部门id`,
prjclass.DICT_NAME `项目分类`,
prjstatus.DICT_NAME `项目状态`,
pm.REAL_NAME `项目经理`,
pd.REAL_NAME `项目总监`,
cust.S_CUSTNAME `客户名称`,
sale.REAL_NAME `销售代表`,
saleorg.S_NAME `销售大区`,
getusername(buz.owner_id) `客户经理`,
tec.tecC `C条线客户经理`,
tec.tecD `D条线客户经理`,
tec.tecO `O条线客户经理`,
p.DT_STARTTIME `项目开始日期`,
p.DT_ENDTIME `项目结束日期`,
p.DT_MAINEND  `项目维保期`,
p.DL_BUDCOAMTI `立项金额`,
buz.S_POCODE `项目商机编号`,
buz.S_PONAME `项目商机名称`,
case LENGTH(p.S_DEPT) when 10 then buzorg1.S_NAME when 13 then CONCAT(buzorg1.S_NAME,'-',buzorg2.S_NAME)
when 16 then CONCAT(buzorg1.S_NAME,'-',buzorg2.S_NAME,'-',buzorg3.S_NAME) END `项目商机所属部门`,
case LENGTH(p.S_DEPT) when 10 then buzorg1.S_NAME when 13 then CONCAT(buzorg1.S_NAME,'-',buzorg2.S_NAME)
when 16 then CONCAT(buzorg1.S_NAME,'-',buzorg2.S_NAME) END `新项目商机归属部门`
from mdl_aos_project p
left join mdl_aos_sapoinf buz on buz.ID = p.I_POID
left join mdl_aos_sacustinf cust on cust.ID = buz.I_CUSTID
left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
left join plf_aos_auth_user pd on pd.ID = p.S_DIRECTOR
left join mdl_aos_hrorg org on org.S_ORGCODE =p.S_DEPT
left join mdl_aos_hrorg org1 on org1.S_ORGCODE =left(p.S_DEPT,10)
left join mdl_aos_hrorg org2 on org2.S_ORGCODE =left(p.S_DEPT,13)
left join mdl_aos_hrorg org3 on org3.S_ORGCODE =left(p.S_DEPT,16)

left join mdl_aos_hrorg buzorg1 on buzorg1.S_ORGCODE =left(buz.ORG_CODE,10)
left join mdl_aos_hrorg buzorg2 on buzorg2.S_ORGCODE =left(buz.ORG_CODE,13)
left join mdl_aos_hrorg buzorg3 on buzorg3.S_ORGCODE =left(buz.ORG_CODE,16)
left join plf_aos_auth_user sale on sale.ID = buz.S_SALEMAN
left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = sale.ORG_CODE
left join (
	SELECT 
	min(case when a.S_DEPTL = 'C' then b.REAL_NAME end) tecC,
	min(CASE WHEN a.S_DEPTL = 'D' then b.REAL_NAME end) tecD,
	min(CASE WHEN a.S_DEPTL = 'O' then b.REAL_NAME END) tecO, a.I_CUSTID
	FROM mdl_aos_sacusttech a left join plf_aos_auth_user b on a.S_TECHID = b.ID
	where a.IS_DELETE = 0
	GROUP BY I_CUSTID
)tec on tec.I_CUSTID = cust.ID
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjclass') prjclass on prjclass.DICT_CODE = p.S_PRJCLASS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjstatus') prjstatus on prjstatus.DICT_CODE = p.S_PRJSTATUS

WHERE p.IS_DELETE = 0  AND p.S_PRJTYPE = 'YY'  AND p.S_PRJSTATUS <> '01' AND p.S_PRJSTATUS <> '06'
-- and org.S_CUT_CODE = 'D'
-- and org1.S_CUT_CODE = 'D'