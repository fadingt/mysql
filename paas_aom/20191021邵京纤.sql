SELECT 
a.*,
b.*
FROM
(
		SELECT 
			project.ID, stage.id stageid, stage.ID `项目阶段ID`,
			S_PRJNO `项目编号`, project.DL_BUDCOAMTI `项目立项金额`, poinf.s_pocode `项目商机编号`,
			case LENGTH(project.S_DEPT) when 10 then org1.ORG_NAME
			when 13 then CONCAT(org1.ORG_NAME,'-',org2.org_name)
			when 16 then CONCAT(org1.ORG_NAME,'-',org2.org_name,'-',org3.ORG_NAME) END `项目归属部门`,
cust.S_CUSTNAME `客户名称`,
CASE WHEN (SELECT DT_FILEDATE from mdl_aos_sacont where IS_DELETE = 0 
and !(S_APPSTATUS != 1 and S_OPERTYPE = 001)
and !(S_OPERTYPE = '003' and S_APPSTATUS <> 2)
and I_POID = poinf.ID
GROUP BY I_POID
)is null then '否' else '是' END `是否签约`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'prjclass' and DICT_CODE = project.S_PRJCLASS) `项目分类`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'prjstatus' and DICT_CODE = project.S_PRJSTATUS) `项目状态`,
			S_PRJNAME `项目名称`,pm.REAL_NAME `项目经理`,
			tec.REAL_NAME `客户经理`,
			tecarea.ORG_NAME	`客户经理部门`,
			sale.REAL_NAME `销售代表`,
			salearea.ORG_NAME `销售所属大区`,
			(select dict_name from plf_aos_dictionary where dict_type = 'PRJSTAGE' and dict_code = stage.s_stagename) `阶段名称`,
			stage.dt_pstadate `阶段预计开始`, stage.dt_penddate `阶段预计结束`, 
			case stage.s_finstatus when 0 then '未完成' when 1 then '已完成' end `阶段完成状态`
		from mdl_aos_project project
		join mdl_aos_sapnotify note on project.I_PRJNOTICE = note.ID and note.is_delete = 0
		left join mdl_aos_sapoinf poinf on poinf.ID = note.I_POID and poinf.is_delete = 0
		left join mdl_aos_sacustinf cust on cust.id = poinf.I_CUSTID
		left join plf_aos_auth_user pm on pm.id = project.S_MANAGER
		left join plf_aos_auth_user pd on pd.id = project.S_DIRECTOR
		left join mdl_aos_prstage stage on stage.i_prjid = project.id and stage.is_delete = 0
		left join plf_aos_auth_user tec on tec.ID = poinf.OWNER_ID
		left join plf_aos_auth_org tecarea on tecarea.ORG_CODE = left(tec.ORG_CODE,13)
		left join plf_aos_auth_user sale on sale.ID = poinf.S_SALEMAN
		left join plf_aos_auth_org salearea on salearea.ORG_CODE = left(sale.ORG_CODE,13)
		left join plf_aos_auth_org org1 on org1.ORG_CODE = left(project.s_dept,10)
		left join plf_aos_auth_org org2 on org2.ORG_CODE = left(project.s_dept,13)
		left join plf_aos_auth_org org3 on org3.ORG_CODE = left(project.s_dept,16)
		where project.IS_DELETE = 0 and project.S_PRJTYPE = 'YY'
)a 
left join (
		SELECT
		(SELECT S_CONCODE from mdl_aos_sacont where ID = C.I_CONID) `合同编号`,
		c.S_STACODE `结算单编号`,
		c.S_STAGEDES `合同/结算单阶段`,
		I_PROID, I_PROSTAGID, a.S_NAME, a.IS_DELETE,
		DL_BACKAMT `项目预回金额`, DL_ASSAMT, DL_ADBILLAMT `项目预开金额`,
		c.DL_ACBACKAMT `合同阶段实回`, c.DL_ACBILLAMT `合同阶段实开`, c.DT_ACBILLD `合同阶段实开日期`, c.DT_ACAMTD `合同阶段实回日期`
		FROM mdl_aos_saordass a
		LEFT JOIN (
					SELECT
						I_PROTNAME I_CONID, o.ID as OrderID, ost.ID OrderStageID, o.S_STACODE, ost.S_STAGEDES,
						ost.DL_ACBILLAMT, DATE_FORMAT(ost.DT_ACBILLD,'%Y%m%d') DT_ACBILLD,
						ost.DL_ACBACKAMT, DATE_FORMAT(ost.DT_ACAMTD,'%Y%m%d') DT_ACAMTD
					from mdl_aos_sastatem o
					left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
					where !ost.IS_DELETE && !o.IS_DELETE
					union all
					SELECT
						contract_id, order_id, NULL, order_no, NULL,
						bill_amt_sum, '20151231',
						rece_amt_sum, '20151231'
					from t_contract_order_month_income
		)C ON c.OrderID = a.I_STATEID and c.OrderStageID = a.I_STASTAGID
		where a.I_CONID is null

		UNION ALL

		SELECT 
		(SELECT S_CONCODE from mdl_aos_sacont where ID = C.I_CONID) S_CONCODE,
		NULL,
		c.stage,
		I_PROID, I_PROSTAGID, a.S_NAME, a.IS_DELETE,
		DL_BACKAMT, DL_ASSAMT, DL_ADBILLAMT,
		c.DL_ACBACKAMT `实回`, c.DL_ACBILLAMT `实开`, c.DT_ACBILLD `实开日期`, c.DT_ACAMTD `实回日期`
		FROM mdl_aos_saordass a
		LEFT JOIN (
					SELECT
						I_CONID, ID AS STAGEID, S_STAGEDES as stage,
						DL_ACBILLAMT, DATE_FORMAT(DT_ACBILLD,'%Y%m%d') DT_ACBILLD,
						DL_ACBACKAMT, DATE_FORMAT(DT_ACAMTD,'%Y%m%d') DT_ACAMTD
					from mdl_aos_saconstag
					where !IS_DELETE
		)C ON c.I_CONID = a.I_CONID and c.STAGEID = a.I_CONSTAID
		where a.I_CONID is not null
)b on a.id = b.I_PROID and a.stageid = b.I_PROSTAGID