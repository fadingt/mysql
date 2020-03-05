select 
project.S_PRJNO `项目编号`,
project.S_PRJNAME `项目名称`,
t.s_pocode `项目商机编号`,
t.s_concode `合同编号`,
sale.real_name `销售代表`,
salearea.S_NAME `销售区域`,
pm.REAL_NAME `项目经理`,
pd.REAL_NAME `项目总监`,
t.S_COMPNAME `所属公司`,
cust.s_custname `客户名称`,
tec.REAL_NAME `客户经理`,
tecarea.S_NAME `客户经理部门`,
DATE_FORMAT(project.DT_STARTTIME,'%Y-%m-%d') AS `开始日期`,
DATE_FORMAT(project.DT_ENDTIME,'%Y-%m-%d') AS `结束日期`,
DATE_FORMAT(project.DT_MAINEND,'%Y-%m-%d') AS `维护日期`,
DATE_FORMAT(t.DT_CONDATE,'%Y-%m-%d') AS `预计合同签约日期`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJCLASS' and DICT_CODE = project.S_PRJCLASS) `项目分类`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJSTATUS' and DICT_CODE = project.S_PRJSTATUS) `项目状态`,
project.DL_BUDCOAMTI AS `立项金额`,
(SELECT SUM(DL_ASSAMT) from mdl_aos_saordass where I_PROID = project.id) `已分配合同额`,
IFNULL(pinc.wnacinc,0) as `往年确认收入`,
IFNULL(pinc.dnacinc,0) as `当年确认收入`,
IFNULL(pinc.wnacinc,0) + IFNULL(pinc.dnacinc,0) as `累计确认收入`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PBaseType' and DICT_CODE = project.S_BASEFULL) `是否充分`,
DATE_FORMAT(project.DT_SETUPTIME,'%Y-%m-%d') `项目创建日期`

from mdl_aos_project project
left join (
		SELECT 
			projectid, SUM(case when yearmonth = 201812 then curmonincome+adjustincome+adjusttax else 0 end) wnacinc,
			SUM(case when left(yearmonth,4) = year(NOW()) then curmonincome+adjustincome+adjusttax else 0 end) dnacinc
		from t_snap_income_projectincome_final a
		GROUP BY projectid
) pinc on pinc.projectid = project.id
left join (
	SELECT 
		poinf.id as poid, note.id as noteid, 
		poinf.S_POCODE, poinf.DT_CONDATE, cont.s_concode,
		poinf.s_saleman, poinf.OWNER_ID as TECH, poinf.i_custid, poinf.I_FINANCEID, comp.S_COMPNAME
	from mdl_aos_sapoinf poinf
	join mdl_aos_sapnotify note on note.i_poid = poinf.id
	left join (
		SELECT  s_concode, i_poid from mdl_aos_sacont 
		where IS_DELETE = 0 and !(S_APPSTATUS != 1 and S_OPERTYPE = 001) and S_OPERTYPE != '003'
	)cont on cont.i_poid = poinf.ID
	left join mdl_aos_compcode comp on comp.ID = poinf.I_FINANCEID
	where !poinf.IS_DELETE and !(poinf.S_APPSTATUS<>1 and poinf.S_OPERTYPE = '001')
	and note.IS_DELETE = 0
) t on t.noteid = project.I_PRJNOTICE

left join plf_aos_auth_user pd on pd.ID = project.S_DIRECTOR
left join plf_aos_auth_user pm on pm.ID = project.S_MANAGER
left join plf_aos_auth_user sale on sale.id = t.s_saleman
left join mdl_aos_hrorg salearea on salearea.S_ORGCODE = left(sale.org_code,13)
left join plf_aos_auth_user tec on tec.id = t.TECH
left join mdl_aos_hrorg tecarea on tecarea.s_orgcode = left(tec.org_code,13)
left join mdl_aos_sacustinf cust on cust.id = t.i_custid
WHERE project.IS_DELETE = 0 AND project.S_PRJTYPE = 'YY'
-- and (select ID from plf_aos_auth_org where ORG_CODE = project.s_dept) in (:datascrope) 
-- {项目编号}{销售代表}{客户经理}{项目经理}