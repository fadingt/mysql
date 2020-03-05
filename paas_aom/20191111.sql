SELECT
-- DISTINCT
case 
when IFNULL(x.amt1,0) = 0 then '退票冲正记录'
WHEN IFNULL(x.amt2,0) = 0 then '合同回款完成'
when IFNULL(sdtl.`预开金额`,0) = IFNULL(sdtl.`实回金额`,0) then '阶段应收账款为0'
 END,
 sdtl.I_CONID, sdtl.`结算单编号/阶段名称`
-- x.*
from mdl_aos_sacont cont
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
				contract_id, '固定金额' type, null `结算单编号/阶段名称`,
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
(sdtl.I_CONID = x.I_CONID and sdtl.type = '固定金额') or (sdtl.I_CONID = x.I_CONID and sdtl.`结算单编号/阶段名称` = x.S_STACODE and sdtl.type = '框架协议')
where !(cont.S_APPSTATUS <> 1 and cont.S_OPERTYPE = 001) and cont.IS_DELETE = 0
and 
case 
when 
IFNULL(sdtl.`实回金额`,0) = 0 and 
x.amt1 = 0 and IFNULL(x.amt3,0) <> 0 then '退票冲正记录'
WHEN IFNULL(x.amt2,0) = 0 then '合同回款完成'
when IFNULL(sdtl.`预开金额`,0) = IFNULL(sdtl.`实回金额`,0) then '阶段应收账款为0'
 END =  '退票冲正记录'
and sdtl.`结算单编号/阶段名称` like '%Contract%'
-- and sdtl.`结算单编号/阶段名称` = 'ContractOrder_940'
ORDER BY sdtl.`结算单编号/阶段名称`
-- 5108
-- 5020


-- ContractOrder_940
-- ContractOrder_917
-- ContractOrder_1527
-- ContractOrder_1528
-- ContractOrder_1083