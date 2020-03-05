SELECT
S_CASECODE `事项编号`,
S_CASENAME `事项名称`,
ngoss.getfullorgname(c.S_DEPT) `事项归属部门`,
project.prjnos `项目编号`,
project.prjamt `已立项金额`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = c.S_APPSTATUS and DICT_TYPE = 'ApproStatus') `事项审核状态`,
DATE_FORMAT(c.DT_CASESTART,'%Y-%m-%d') `事项开始日期`,
DATE_FORMAT(c.DT_CASEEND,'%Y-%m-%d')  `事项结束日期`,
DATE_FORMAT(c.DT_SIGNTIME,'%Y-%m-%d') `签约日期`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = c.S_SIGNTYPE and DICT_TYPE = 'signType') `签约子类型`,
c.DL_CASEMONEY `事项金额`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = c.S_CASESTATE and DICT_TYPE = 'casestatus') `事项状态`,
ngoss.getusername(c.OWNER_ID) `创建人`,
DATE_FORMAT(c.CREATE_TIME,'%Y-%m-%d') `创建时间`,
poinf.S_POCODE `项目商机编号`,
poinf.S_PONAME `项目商机名称`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = poinf.S_CONSTATE and DICT_TYPE = 'bussCONstate') `签约状态`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = poinf.S_PROATTR and DICT_TYPE = 'PROATTR') `项目属性`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = poinf.S_POSTAGE and DICT_TYPE = 'POSTAGE') `项目商机阶段`,
cust.S_CUSTNAME `签约客户`,
impcust.S_CUSTNAME `实施客户`,
comp.S_COMPNAME `财务主体`,sale.REAL_NAME `销售代表`,
salearea.S_NAME `销售区域`,
tec.REAL_NAME `客户经理`,
tecarea.S_NAME `客户经理区域`,
DATE_FORMAT(poinf.DT_CONDATE,'%Y-%m-%d')	 `预计签约日期`,
DATE_FORMAT(case when DT_PRODATE is null then DT_PREBEGD else DT_PRODATE END,'%Y-%m-%d') `项目预计开始日期`,
poinf.DL_SUMAMT `项目商机预计总价`,
( SELECT S_CONCODE FROM mdl_aos_sacont WHERE IS_DELETE = 0 AND S_CONSTATUS != '02' and I_POID = c.I_POID GROUP BY I_POID) `合同编号`,
-- IFNULL(checkstg.`应验阶段数`,0) `应验阶段数`,
-- IFNULL(checkstg.`已验阶段数`,0) `已验阶段数`
checkstg.`应验阶段数`,checkstg.`已验阶段数`

from mdl_aos_sacase c
left join mdl_aos_sapoinf poinf on c.I_POID = poinf.ID
left join (
	SELECT I_CASEID, GROUP_CONCAT(S_PRJNO) prjnos, SUM(DL_BUDCOAMTI) prjamt
	from mdl_aos_project where IS_DELETE = 0 and S_PRJSTATUS <> '01'
	GROUP BY I_CASEID
) project on project.i_caseid = c.ID
left join (
	SELECT I_CASEID,
	COUNT(case when  cstg.S_IFMAIN = 1 then 1 END) `应验阶段数`,
	COUNT(case when cstg.S_IFCHECK = 2 and cstg.S_IFMAIN = 1 then 1 END) `已验阶段数`
	FROM `mdl_aos_sacheckstg` cstg
	where cstg.IS_DELETE = 0 and S_TYPE = 2
	GROUP BY I_CASEID
)checkstg on checkstg.I_CASEID = c.ID
left join mdl_aos_sacustinf cust on cust.ID = poinf.I_CUSTID
left join mdl_aos_sacustinf impcust on impcust.ID = poinf.I_IMPCUSTID
left join mdl_aos_compcode comp on comp.ID = poinf.I_FINANCEID
left join plf_aos_auth_user tec on tec.ID = poinf.OWNER_ID
left join plf_aos_auth_user sale on sale.ID = poinf.S_SALEMAN
left join mdl_aos_hrorg tecarea on tecarea.S_ORGCODE = left(tec.org_code,13)
left join mdl_aos_hrorg salearea on salearea.S_ORGCODE = left(sale.org_code,13)
where c.IS_DELETE = 0 and c.S_APPSTATUS = 1