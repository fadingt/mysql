			SELECT
				I_PROTNAME, '框架协议', o.S_STACODE,
				ost.DL_ACBILLAMT, DATE_FORMAT(ost.DT_ACBILLD,'%Y%m'),
				ost.DL_ACBACKAMT, DATE_FORMAT(ost.DT_ACAMTD,'%Y%m'),
				ost.DL_BILLAMT, 
				case when ost.DT_ACBILLD is not null and ost.DT_PREBILLD>ost.DT_ACBILLD then DATE_FORMAT(ost.DT_ACBILLD,'%Y%m') else DATE_FORMAT(ost.DT_PREBILLD,'%Y%m') end,
				ost.DL_BACKAMT, 
				case when ost.DT_ACAMTD is not null and ost.DT_PREBACKD>ost.DT_ACAMTD then DATE_FORMAT(ost.DT_ACAMTD,'%Y%m') else DATE_FORMAT(ost.DT_PREBACKD,'%Y%m') end,
''
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where 1=1
and !ost.IS_DELETE && !o.IS_DELETE 
and !(IFNULL(o.S_OPTYPE,0) = '003' and o.S_APPSTATUS = 1)
-- and IFNULL(ost.DL_ACBACKAMT,0) = 0
and S_STACODE = 'ContractOrder_940';
-- and S_STACODE = 'ContractOrder_4'
-- GROUP BY I_PROTNAME, o.S_STACODE
-- HAVING SUM(ost.DL_BACKAMT) = 0 and SUM(ost.DL_BILLAMT) = 0
-- ORDER BY S_STACODE