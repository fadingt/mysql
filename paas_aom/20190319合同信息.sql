SELECT 
	cont.CREATE_TIME `合同创建日期`,
	S_CONCODE `合同编号`,
	S_CONNAME `合同名称`,
	ApproStatus.dict_name `审批状态`,
	CONSTATUS.dict_name `合同状态`,
	IFNULL(PROTCATE.dict_name,cate.dict_name) `合同类型`,
	cust.S_CUSTNAME `甲方`, partyb.S_NAME `乙方`,
	tec1.REAL_NAME `客户经理A`, tec2.REAL_NAME `客户经理B`,	tec1area.ORG_NAME `客户经理A所属区域`,
	sale.REAL_NAME `销售代表`, salearea.ORG_NAME `销售区域`,
	po.S_POCODE `所属项目商机编号`, po.S_PONAME `所属项目商机名称`,
	DATE_FORMAT(cont.DT_BEGDATE,'%Y-%m-%d') `合同开始日期`,
	DATE_FORMAT(cont.DT_ENDDATE,'%Y-%m-%d') `合同结束日期`,
	DATE_FORMAT(cont.DT_PSIGNDATE,'%Y-%m-%d') `预计签约日期`,
	DATE_FORMAT(cont.DT_ASIGNDATE,'%Y-%m-%d') `实际签约日期`,
	DATE_FORMAT(DT_FILEDATE,'%Y-%m-%d') `归档日期`,
	cont.DL_CONAMT `合同额`,
	sdtl.*
from mdl_aos_sacont cont
left join (
		SELECT
			cont.ID as I_CONID,
			SUM(case when left(dtl.DT_ACBILLD,4) < year(NOW()) then dtl.DL_ACBILLAMT else 0 end) `往年实开`,
			SUM(case when left(dtl.DT_ACBILLD,4) = year(NOW()) and dtl.DT_ACBILLD <DATE_FORMAT(NOW(),'%Y%m') then dtl.DL_ACBILLAMT else 0 end) `当年实开(不含当月)`,
			SUM(case when dtl.DT_ACBILLD =DATE_FORMAT(NOW(),'%Y%m') then dtl.DL_ACBILLAMT else 0 end) `当月实开`,

			SUM(case when left(dtl.DT_ACAMTD,4) < year(NOW()) then dtl.DL_ACBACKAMT else 0 end) `往年实回`,
			SUM(case when left(dtl.DT_ACAMTD,4) = year(NOW()) and dtl.DT_ACAMTD <DATE_FORMAT(NOW(),'%Y%m') then dtl.DL_ACBACKAMT else 0 end) `当年实回(不含当月)`,
			SUM(case when dtl.DT_ACAMTD =DATE_FORMAT(NOW(),'%Y%m') then dtl.DL_ACBACKAMT else 0 end) `当月实回`
		from mdl_aos_sacont cont
		left join (
			SELECT
				contract_id as I_CONID, '固定金额' as type,
				bill_amt_sum as DL_ACBILLAMT, income_month as DT_ACBILLD, 
				rece_amt_sum as DL_ACBACKAMT, income_month as DT_ACAMTD
			from t_contract_month_income
			union all
			SELECT
				I_CONID, '固定金额',
				DL_ACBILLAMT, DATE_FORMAT(DT_ACBILLD,'%Y%m'), DL_ACBACKAMT, DATE_FORMAT(DT_ACAMTD,'%Y%m')
			from mdl_aos_saconstag
			where !IS_DELETE && (S_BILLSTA || S_BACKSTA)

			union all

			SELECT
				contract_id as I_CONID, '框架协议' as type,
				bill_amt_sum as DL_ACBILLAMT, income_month as DT_ACBILLD, 
				rece_amt_sum as DL_ACBACKAMT, income_month as DT_ACAMTD
			from t_contract_order_month_income
			union all
			SELECT
				I_PROTNAME, '框架协议',
				ost.DL_ACBILLAMT, DATE_FORMAT(DT_ACBILLD,'%Y%m'),
				ost.DL_ACBACKAMT, DATE_FORMAT(DT_ACAMTD,'%Y%m')
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where o.S_STATYPE && !ost.IS_DELETE && ( S_BILLSTA || S_BACKSTA)
		)dtl on dtl.I_CONID = cont.ID
		GROUP BY cont.ID
) sdtl on sdtl.I_CONID = cont.id
left join mdl_aos_sapoinf po on po.ID = cont.I_POID
left join mdl_aos_sacustinf pocust on po.I_CUSTID = pocust.ID

left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'contactCategory') cate on cate.dict_code = cont.S_CONCATE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'contactType') CONSTATUS on CONSTATUS.dict_code = cont.s_CONSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.dict_code = cont.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'PROTCATE') PROTCATE on PROTCATE.dict_code = cont.S_PROTCATE
left join mdl_aos_sacustinf cust on cust.ID = cont.S_PARTYA
left join mdl_aos_hrorg partyb on partyb.ID = cont.S_PARTYB
left join plf_aos_auth_user tec1 on tec1.ID = pocust.S_FIRTECH
left join plf_aos_auth_user tec2 on tec2.ID = pocust.S_SECTECH
left join plf_aos_auth_user sale on sale.ID = cont.OWNER_ID
left join plf_aos_auth_org salearea on salearea.ORG_CODE = left(sale.ORG_CODE,13)
left join plf_aos_auth_org tec1area on tec1area.ORG_CODE = left(tec1.ORG_CODE,13)