SELECT 
case 
when IFNULL(sdtl.`实回金额`,0) = 0 and x.amt1 = 0 and IFNULL(x.amt3,0) <> 0 then '退票冲正记录'
WHEN IFNULL(x.amt2,0) = 0 then '合同回款完成'
when IFNULL(sdtl.`预开金额`,0) = IFNULL(sdtl.`实回金额`,0) then '阶段应收账款为0'
 END `备注`,
cont.id,
	cont.CREATE_TIME `合同创建日期`,
	S_CONCODE `合同编号`,
	S_CONNAME `合同名称`,
	ngoss.getusername(cont.OWNER_ID) `销售代表`,
	salearea.ORG_NAME `销售大区`,
-- 	ngoss.translatedict('ApproStatus',cont.S_APPSTATUS) `审批状态`,
	ngoss.translatedict('contactType',S_CONSTATUS)`合同状态`,
	DATE_FORMAT(cont.DT_PSIGNDATE,'%Y-%m-%d') `预计签约日期`,
	DATE_FORMAT(cont.DT_ASIGNDATE,'%Y-%m-%d') `实际签约日期`,
	DATE_FORMAT(DT_FILEDATE,'%Y-%m-%d') `归档日期`,
	case 
	when S_CONTYPE = '01' then cont.DL_CONAMT 
	when S_CONTYPE = '02' then (SELECT SUM(DL_STATEMAMT) from mdl_aos_sastatem o where o.IS_DELETE = 0
and o.I_PROTNAME = cont.ID)
	else 0
	end`合同额`,
	sdtl.*
from mdl_aos_sacont cont
left join plf_aos_auth_user sale on sale.ID = cont.OWNER_ID
left join plf_aos_auth_org salearea on salearea.ORG_CODE = left(sale.ORG_CODE,13)
left join (
			SELECT
				I_CONID, '固定金额' type, S_STAGEDES `结算单编号/阶段名称`,
				DL_ACBILLAMT `实开金额`, DATE_FORMAT(DT_ACBILLD,'%Y%m') `实开月份`,
				DL_ACBACKAMT `实回金额`, DATE_FORMAT(DT_ACAMTD,'%Y%m') `实回月份`,-- 实回
				DL_BILLAMT `预开金额`, 
				case when DT_ACBILLD is not null and DT_PREBILLD>DT_ACBILLD  then DATE_FORMAT(DT_ACBILLD,'%Y%m') else DATE_FORMAT(DT_PREBILLD,'%Y%m') end as `预开月份`,-- 预开
				DL_BACKAMT `预回金额`, 
				case when DT_ACAMTD is not null and DT_PREBACKD>DT_ACAMTD then DATE_FORMAT(DT_ACAMTD,'%Y%m') else DATE_FORMAT(DT_PREBACKD,'%Y%m') end as `预回月份`-- 预回 
			from mdl_aos_saconstag
			where !IS_DELETE
			union all
			SELECT
				I_PROTNAME, '框架协议', o.S_STACODE,
				ost.DL_ACBILLAMT, DATE_FORMAT(ost.DT_ACBILLD,'%Y%m'),
				ost.DL_ACBACKAMT, DATE_FORMAT(ost.DT_ACAMTD,'%Y%m'),
				ost.DL_BILLAMT, 
				case when ost.DT_ACBILLD is not null and ost.DT_PREBILLD>ost.DT_ACBILLD then DATE_FORMAT(ost.DT_ACBILLD,'%Y%m') else DATE_FORMAT(ost.DT_PREBILLD,'%Y%m') end,
				ost.DL_BACKAMT, 
				case when ost.DT_ACAMTD is not null and ost.DT_PREBACKD>ost.DT_ACAMTD then DATE_FORMAT(ost.DT_ACAMTD,'%Y%m') else DATE_FORMAT(ost.DT_PREBACKD,'%Y%m') end
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where !ost.IS_DELETE && !o.IS_DELETE and !(IFNULL(o.S_OPTYPE,'') = '003' and o.S_APPSTATUS = 1)

			union all
			SELECT
				contract_id, '固定金额' type, null `结算单编号2`,
				bill_amt_sum, income_month, -- 实开
				rece_amt_sum, income_month,-- 实回
				bill_amt_sum, income_month, -- 预开
				rece_amt_sum, income_month-- 预回 
			from t_contract_month_income
			union ALL
			SELECT
				contract_id, '框架协议' type, order_no `结算单编号2`,
				bill_amt_sum, income_month, -- 实开
				rece_amt_sum, income_month,-- 实回
				bill_amt_sum, income_month, -- 预开
				rece_amt_sum, income_month-- 预回 
			from t_contract_order_month_income
) sdtl on sdtl.I_CONID = cont.ID
left join (-- 合同状态 是否回款完成 退票冲正 阶段应收账款为0
	SELECT
		I_CONID, '固定金额' type, null S_STACODE,
		SUM(case when IFNULL(DL_ACBACKAMT,0) = 0 then IFNULL(DL_BILLAMT,0) END) amt1,
		SUM(IFNULL(DL_BILLAMT,0) - IFNULL(DL_ACBACKAMT,0)) amt2,
		SUM(DL_BILLAMT) amt3
	from mdl_aos_saconstag where !IS_DELETE
	GROUP BY I_CONID

	union all

	SELECT
		I_PROTNAME, '框架协议', o.S_STACODE,
		SUM(case when IFNULL(ost.DL_ACBACKAMT,0) = 0 then IFNULL(DL_BILLAMT,0) end),
		SUM(IFNULL(DL_BILLAMT,0) - IFNULL(DL_ACBACKAMT,0)),
		SUM(DL_BILLAMT)
	from mdl_aos_sastatem o
	left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
	where 1=1
		and !ost.IS_DELETE && !o.IS_DELETE 
		and !(IFNULL(o.S_OPTYPE,0) = '003' and o.S_APPSTATUS = 1)
	GROUP BY I_PROTNAME, o.S_STACODE
)x on 
sdtl.`预开月份` <> 201512 and 
((sdtl.I_CONID = x.I_CONID and sdtl.type = '固定金额') or (sdtl.I_CONID = x.I_CONID and sdtl.`结算单编号/阶段名称` = x.S_STACODE and sdtl.type = '框架协议'))

where !(cont.S_APPSTATUS <> 1 and cont.S_OPERTYPE = 001) and cont.IS_DELETE = 0
and case 
when IFNULL(sdtl.`实回金额`,0) = 0 and x.amt1 = 0 and IFNULL(x.amt3,0) <> 0 then '退票冲正记录'
WHEN IFNULL(x.amt2,0) = 0 then '合同回款完成'
when IFNULL(sdtl.`预开金额`,0) = IFNULL(sdtl.`实回金额`,0) then '阶段应收账款为0'
 END  = '退票冲正记录'
and sdtl.`结算单编号/阶段名称` like '%Contract%'