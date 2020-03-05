			SELECT
				contract_id as I_CONID, '固定金额' as type, null `阶段描述/结算单编号`,-- 阶段描述
				bill_amt_sum as DL_ACBILLAMT, income_month as DT_ACBILLD, -- 实开
				rece_amt_sum as DL_ACBACKAMT, income_month as DT_ACAMTD,-- 实回
				null DL_ACBACKAMT, null DT_PREBILLD,-- 预开
				null DL_BACKAMT, null DT_PREBACKD -- 预回 
			from t_contract_month_income
			union all
			SELECT
				I_CONID, '固定金额', S_STAGEDES,
				DL_ACBILLAMT, DATE_FORMAT(DT_ACBILLD,'%Y%m'), 
				DL_ACBACKAMT, DATE_FORMAT(DT_ACAMTD,'%Y%m'),
				DL_BILLAMT, DATE_FORMAT(DT_PREBILLD,'%Y%m'),
				DL_BACKAMT, DATE_FORMAT(DT_PREBACKD,'%Y%m')
			from mdl_aos_saconstag
			where !IS_DELETE && S_APPSTATUS=1

			union all

			SELECT
				contract_id as I_CONID, '框架协议' as type, order_id, -- `结算单编号`
				bill_amt_sum as DL_ACBILLAMT, income_month as DT_ACBILLD, 
				rece_amt_sum as DL_ACBACKAMT, income_month as DT_ACAMTD,
				null, null, null, null -- 预开 预回 
			from t_contract_order_month_income
			union all
			SELECT
				I_PROTNAME, '框架协议', o.S_STACODE,
				ost.DL_ACBILLAMT, DATE_FORMAT(ost.DT_ACBILLD,'%Y%m'),
				ost.DL_ACBACKAMT, DATE_FORMAT(ost.DT_ACAMTD,'%Y%m'),
				ost.DL_BILLAMT, DATE_FORMAT(ost.DT_PREBILLD,'%Y%m'),
				ost.DL_BACKAMT, DATE_FORMAT(ost.DT_PREBACKD,'%Y%m')
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where !ost.IS_DELETE && !o.IS_DELETE && (o.S_APPSTATUS=1) && (ost.S_APPSTATUS=1)