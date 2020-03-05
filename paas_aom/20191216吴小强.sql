-- 当年已签约额	 当年待签立项额	 待签最长预警天数	
-- 合同已归档份数	 合同待归档份数	
-- 当年已确认收入额	 当年待确认收入	
-- 当年已确认库存额	 已票应收额	
-- 当年已开票额	 当年待开票额	
-- 当年已回款额	 当年待汇款额	
-- 当年已验收额	 当年待验收额	
-- 当年已结算额	 当年待结算额	 已结算月份	

SELECT 
IFNULL(prj.DL_BUDCOAMTI,0) `已立项金额`, IFNULL(prj.diff,0) `预警天数`, IFNULL(prj.cnt,0) `已立项数`,
cont.S_CONCODE `合同编号`, cont.S_CONNAME `合同名称`, cont.DT_FILEDATE `归档日期`, cont.S_FILSTATUS, cont.CREATE_TIME, cont.LAST_UPDATE_TIME, 
cont.S_PARTYA, cont.S_PARTYB, cust.S_CUSTNAME,
 sale.REAL_NAME `销售代表`, salearea.S_NAME `销售大区`,
case when cont.S_CONTYPE = 02 then IFNULL((SELECT SUM(DL_STATEMAMT) from mdl_aos_sastatem where IS_DELETE = 0 and S_STATYPE = 1 and S_OPTYPE <> 003 and I_PROTNAME = cont.ID),0)
when cont.S_CONTYPE = 01 then cont.DL_CONAMT END `合同额`, cont.S_CONTYPE,

billrece.*, checkstg.`当年已验金额`, checkstg.`当年应验金额`
FROM mdl_aos_sacont cont
left join (
		SELECT
		t.I_CONID, 
		IFNULL(SUM(CASE WHEN year(t.`合同阶段实开日期`) = year(NOW()) then t.`合同阶段实开` END),0) `当年实开`,
		IFNULL(SUM(case when year(t.`合同阶段预开日期`) = year(NOW()) then t.`合同阶段预开` END),0) `当年预开`,
		IFNULL(SUM(CASE WHEN year(t.`合同阶段实回日期`) = year(NOW()) then t.`合同阶段实开` END),0) `当年实回`,
		IFNULL(SUM(case when year(t.`合同阶段预回日期`) = year(NOW()) then t.`合同阶段预回` END),0) `当年预回`
		-- t.*
		FROM(
				SELECT
				C.I_CONID,
				c.S_STACODE `结算单编号`,
				c.S_STAGEDES `合同/结算单阶段`,
				I_PROID, I_PROSTAGID,	a.DL_BACKAMT `项目预回`, DL_PRBILLAMT `项目预开`,
				c.DL_ACBACKAMT `合同阶段实回`, c.DL_ACBILLAMT `合同阶段实开`, c.DT_ACBILLD `合同阶段实开日期`, c.DT_ACAMTD `合同阶段实回日期`,
				c.DL_BILLAMT `合同阶段预开`, c.DL_BACKAMT `合同阶段预回`, c.DT_PREBILLD `合同阶段预开日期`, c.DT_PREBACKD `合同阶段预回日期`
				FROM mdl_aos_saordass a
				LEFT JOIN (
							SELECT
								I_PROTNAME I_CONID, o.ID as OrderID, ost.ID OrderStageID, o.S_STACODE, ost.S_STAGEDES,
								ost.DL_ACBILLAMT, DATE_FORMAT(ost.DT_ACBILLD,'%Y%m%d') DT_ACBILLD,
								ost.DL_ACBACKAMT, DATE_FORMAT(ost.DT_ACAMTD,'%Y%m%d') DT_ACAMTD,
								ost.DL_BILLAMT, DATE_FORMAT(ost.DT_PREBILLD,'%Y%m%d') DT_PREBILLD,
								ost.DL_BACKAMT, DATE_FORMAT(ost.DT_PREBACKD,'%Y%m%d') DT_PREBACKD
							from mdl_aos_sastatem o
							left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
							where !ost.IS_DELETE && !o.IS_DELETE
							union all
							SELECT
								contract_id, order_id, NULL, order_no, NULL,
								bill_amt_sum, '20151231',
								rece_amt_sum, '20151231',
								bill_amt_sum, '20151231',
								rece_amt_sum, '20151231'
							from t_contract_order_month_income
				)C ON c.OrderID = a.I_STATEID and c.OrderStageID = a.I_STASTAGID
				where a.I_CONID is null and a.IS_DELETE = 0 and c.I_CONID is not null

				UNION ALL

				SELECT 
				a.I_CONID,
				NULL,
				c.stage,
				I_PROID, I_PROSTAGID, a.DL_BACKAMT,DL_PRBILLAMT,
				c.DL_ACBACKAMT `实回`, c.DL_ACBILLAMT `实开`, c.DT_ACBILLD `实开日期`, c.DT_ACAMTD `实回日期`,
				c.DL_BILLAMT `合同阶段预开`, c.DL_BACKAMT `合同阶段预回`, c.DT_PREBILLD `合同阶段预开日期`, c.DT_PREBACKD `合同阶段与会日期`
				FROM mdl_aos_saordass a
				LEFT JOIN (
							SELECT
								I_CONID, ID AS STAGEID, S_STAGEDES as stage,
								DL_ACBILLAMT, DATE_FORMAT(DT_ACBILLD,'%Y%m%d') DT_ACBILLD,
								DL_ACBACKAMT, DATE_FORMAT(DT_ACAMTD,'%Y%m%d') DT_ACAMTD,
								DL_BILLAMT, DATE_FORMAT(DT_PREBILLD,'%Y%m%d') DT_PREBILLD,
								DL_BACKAMT, DATE_FORMAT(DT_PREBACKD,'%Y%m%d') DT_PREBACKD
							from mdl_aos_saconstag
							where !IS_DELETE
				)C ON c.I_CONID = a.I_CONID and c.STAGEID = a.I_CONSTAID
				where a.I_CONID is not null and a.IS_DELETE = 0
		)t
		GROUP BY t.I_CONID
)billrece on cont.ID = billrece.I_CONID
LEFT JOIN (
		SELECT
		b.I_CONID, 
		SUM(case when year(a.DT_CHECKDATE) = year(now()) and S_IFCHECK = 2 and S_IFMAIN = 1 then a.DL_CHECKAMT else 0 END) `当年已验金额`, 
		SUM(case when year(a.DT_CHECKTIME) = year(now()) and a.S_IFMAIN = 1 then a.DL_CHECKAMT else 0 END) `当年应验金额`
		from mdl_aos_sacheckstg a
		left join mdl_aos_sacheckapp b on a.I_CKID = b.ID
		where a.S_TYPE = 3 and a.IS_DELETE = 0
		GROUP BY b.I_CONID
)checkstg on checkstg.I_CONID = cont.ID
left join (
		SELECT 
			I_POID, SUM(DL_BUDCOAMTI) DL_BUDCOAMTI, DATEDIFF(MIN(DT_STARTTIME),NOW()) diff, COUNT(ID) cnt
		from mdl_aos_project
		where IS_DELETE = 0 and S_PRJTYPE = 'YY' and S_PRJSTATUS <> 06 and S_PRJSTATUS <> 01
		GROUP BY I_POID
)prj on prj.I_POID = cont.I_POID
left join mdl_aos_sacustinf cust on cust.id = cont.S_PARTYA
left join plf_aos_auth_user sale on sale.ID = cont.OWNER_ID
left join mdl_aos_hrorg salearea on salearea.S_ORGCODE = left(sale.org_code,13)
where cont.IS_DELETE = 0 and cont.S_OPERTYPE <> '003'