select 
project.S_PRJNO `项目编号`,
project.S_PRJNAME `项目名称`,
pm.REAL_NAME `项目经理`,
pd.REAL_NAME `项目总监`,
tec.REAL_NAME `客户经理`,
tecarea.S_NAME `客户经理部门`,
case LENGTH(project.S_DEPT)
when 10 then org1.ORG_NAME
when 13 then CONCAT(org1.ORG_NAME,'-',org2.ORG_NAME)
when 16 then CONCAT(org1.ORG_NAME,'-',org2.ORG_NAME,'-',org3.ORG_NAME)
END `项目所属部门`,
DATE_FORMAT(project.DT_STARTTIME,'%Y-%m-%d') AS `开始日期`,
DATE_FORMAT(project.DT_ENDTIME,'%Y-%m-%d') AS `结束日期`,
DATE_FORMAT(project.DT_MAINEND,'%Y-%m-%d') AS `维护日期`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJCLASS' and DICT_CODE = project.S_PRJCLASS) `项目分类`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJSTATUS' and DICT_CODE = project.S_PRJSTATUS) `项目状态`,
(SELECT DICT_NAME FROM plf_aos_dictionary WHERE DICT_TYPE = 'PRJATTR' AND DICT_CODE = project.S_ISZL) `项目属性`,
case project.S_FINACLOSE when 1 then '否' when 2 then '是' end `财务关闭`,
(SELECT DICT_NAME FROM plf_aos_dictionary WHERE DICT_TYPE = 'ApproStatus' AND DICT_CODE = project.S_APPSTATUS) `审批状态`, 
(SELECT DICT_NAME FROM plf_aos_dictionary WHERE DICT_TYPE = 'OPERTYPE' AND DICT_CODE = project.S_OPERTYPE) `操作类型` ,
project.DL_BUDCOAMTI AS `立项金额`,
project.DL_BUDTOLCOS `预算总成本`,
project.DL_BUDLABAMT `预算人力成本`,
project.DL_BUDPURAMT `预算采购成本`,
project.DL_BUDCOSAMT `预算费用成本`,
project.DL_BUDGRRATE `预算毛利率`,
null remark
-- sale.real_name `销售代表`,
-- salearea.S_NAME `销售区域`,
-- t.S_COMPNAME `所属公司`,
-- cust.s_custname `客户名称`,
-- (SELECT dict_name from plf_aos_dictionary where DICT_CODE = S_IDC1 and DICT_TYPE = 'IDC1') `解决方案`, 
-- (SELECT dict_name from plf_aos_dictionary where DICT_CODE = S_IDC2 and DICT_TYPE = 'IDC2') `解决子案2`,
-- DATE_FORMAT(t.DT_CONDATE,'%Y-%m-%d') AS `预计合同签约日期`

from mdl_aos_project project

left join (
	SELECT 
		poinf.id as poid, note.id as noteid, 
		poinf.S_POCODE, poinf.DT_CONDATE,
		poinf.s_saleman, poinf.OWNER_ID as TECH, poinf.i_custid, poinf.I_FINANCEID, comp.S_COMPNAME
	from mdl_aos_sapoinf poinf
	join mdl_aos_sapnotify note on note.i_poid = poinf.id
	left join mdl_aos_compcode comp on comp.ID = poinf.I_FINANCEID
	where !poinf.IS_DELETE and !(poinf.S_APPSTATUS<>1 and poinf.S_OPERTYPE = '001')
	and note.IS_DELETE = 0
) t on t.noteid = project.I_PRJNOTICE
left join plf_aos_auth_user pd on pd.ID = project.S_DIRECTOR
left join plf_aos_auth_user pm on pm.ID = project.S_MANAGER
left join plf_aos_auth_user tec on tec.id = t.TECH
left join mdl_aos_hrorg tecarea on tecarea.s_orgcode = left(tec.org_code,13)
left join mdl_aos_sacustinf cust on cust.id = t.i_custid
left join plf_aos_auth_org org1 on org1.ORG_CODE = left(project.S_DEPT,10)
left join plf_aos_auth_org org2 on org2.ORG_CODE = left(project.S_DEPT,13)
left join plf_aos_auth_org org3 on org3.ORG_CODE = left(project.S_DEPT,16)

WHERE project.IS_DELETE = 0 AND project.S_PRJTYPE = 'YY'