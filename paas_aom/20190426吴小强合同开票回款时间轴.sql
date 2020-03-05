SELECT 
cont.id,S_CONTYPE,
-- 	cont.CREATE_TIME `合同创建日期`,
	t.yearmonth `年月`,
	S_CONCODE `合同编号`,
	S_CONNAME `合同名称`,
	case 
	when S_CONTYPE = '01' then cont.DL_CONAMT 
	when S_CONTYPE = '02' then (SELECT SUM(DL_STATEMAMT) from mdl_aos_sastatem o where o.IS_DELETE = 0
	and o.I_PROTNAME = cont.ID)
	else 0
	end`合同额`,
	IFNULL(sbill.`实开`,0) `实开`,
	IFNULL(srece.`实回`,0) `实回`,
	IFNULL(ybill.`预开`,0) `预开`,
	IFNULL(yrece.`预回`,0) `预回`,
	ngoss.getusername(cont.OWNER_ID) `销售代表`,
	salearea.ORG_NAME `销售大区`,
-- 	ngoss.translatedict('ApproStatus',cont.S_APPSTATUS) `审批状态`,
	ngoss.translatedict('contactType',S_CONSTATUS)`合同状态`,
	DATE_FORMAT(cont.DT_PSIGNDATE,'%Y-%m-%d') `预计签约日期`,
	DATE_FORMAT(cont.DT_ASIGNDATE,'%Y-%m-%d') `实际签约日期`,
	DATE_FORMAT(DT_FILEDATE,'%Y-%m-%d') `归档日期`
from mdl_aos_sacont cont
left join plf_aos_auth_user sale on sale.ID = cont.OWNER_ID
left join plf_aos_auth_org salearea on salearea.ORG_CODE = left(sale.ORG_CODE,13)
join (
	SELECT	DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') yearmonth
	from mdl_aos_canlender where year(DT_CANDAY) = 2019
)t
left join (
			SELECT
				I_CONID conid1, DATE_FORMAT(DT_ACBILLD,'%Y%m') billym,
				SUM(DL_ACBILLAMT) `实开`
			from mdl_aos_saconstag
			where !IS_DELETE && DL_ACBILLAMT <>0 && DT_ACBILLD<>0
			GROUP BY DATE_FORMAT(DT_ACBILLD,'%Y%m'), I_CONID
			union all
			SELECT
				I_PROTNAME,DATE_FORMAT(ost.DT_ACBILLD,'%Y%m'),
				ost.DL_ACBILLAMT
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where !ost.IS_DELETE && !o.IS_DELETE && ost.DL_ACBILLAMT<>0 && ost.DT_ACBILLD<>0
			GROUP BY DATE_FORMAT(ost.DT_ACBILLD,'%Y%m'),I_PROTNAME
) sbill on sbill.conid1 = cont.ID and sbill.billym = t.yearmonth
left join (
			SELECT
				I_CONID conid2, DATE_FORMAT(DT_PREBILLD,'%Y%m') ybillym,
				SUM(DL_BILLAMT) `预开`
			from mdl_aos_saconstag
			where !IS_DELETE && DL_BILLAMT <>0 && DT_PREBILLD<>0
			GROUP BY DATE_FORMAT(DT_PREBILLD,'%Y%m'), I_CONID
			union all
			SELECT
				I_PROTNAME,
				case when ost.DT_ACBILLD is not null and ost.DT_PREBILLD>ost.DT_ACBILLD then DATE_FORMAT(ost.DT_ACBILLD,'%Y%m') else DATE_FORMAT(ost.DT_PREBILLD,'%Y%m') end,
				ost.DL_BILLAMT
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where !ost.IS_DELETE && !o.IS_DELETE && ost.DL_BILLAMT<>0 && ost.DT_PREBILLD<>0
			GROUP BY 
				(case when ost.DT_ACBILLD is not null and ost.DT_PREBILLD>ost.DT_ACBILLD then DATE_FORMAT(ost.DT_ACBILLD,'%Y%m') else DATE_FORMAT(ost.DT_PREBILLD,'%Y%m') end),
				I_PROTNAME
) ybill on ybill.conid2 = cont.ID and ybill.ybillym = t.yearmonth
left join (
			SELECT
				I_CONID conid3, DATE_FORMAT(DT_ACAMTD,'%Y%m') sreceym,
				SUM(DL_ACBACKAMT) `实回`
			from mdl_aos_saconstag
			where !IS_DELETE && DL_ACBACKAMT<>0 && DT_ACAMTD<>0
			GROUP BY DATE_FORMAT(DT_ACAMTD,'%Y%m'), I_CONID
			union all
			SELECT
				I_PROTNAME, DATE_FORMAT(ost.DT_ACAMTD,'%Y%m'),
				ost.DL_ACBACKAMT
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where !ost.IS_DELETE && !o.IS_DELETE && ost.DT_ACAMTD<>0 && ost.DL_ACBACKAMT<>0
			GROUP BY DATE_FORMAT(ost.DT_ACAMTD,'%Y%m'),I_PROTNAME
)srece on srece.conid3 = cont.ID and srece.sreceym = t.yearmonth
left join (
			SELECT
				I_CONID contid4,
				case when DT_ACAMTD is not null and DT_PREBACKD>DT_ACAMTD then DATE_FORMAT(DT_ACAMTD,'%Y%m') else DATE_FORMAT(DT_PREBACKD,'%Y%m') end yreceym,
				SUM(DL_BACKAMT) `预回`
			from mdl_aos_saconstag
			where !IS_DELETE && DL_BACKAMT<>0 && DT_PREBACKD<>0
			GROUP BY 
				case when DT_ACAMTD is not null and DT_PREBACKD>DT_ACAMTD then DATE_FORMAT(DT_ACAMTD,'%Y%m') else DATE_FORMAT(DT_PREBACKD,'%Y%m') end,
				I_CONID
			union all
			SELECT
				I_PROTNAME,
				case when ost.DT_ACAMTD is not null and ost.DT_PREBACKD>ost.DT_ACAMTD then DATE_FORMAT(ost.DT_ACAMTD,'%Y%m') else DATE_FORMAT(ost.DT_PREBACKD,'%Y%m') end,
				SUM(ost.DL_BACKAMT)
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where !ost.IS_DELETE && !o.IS_DELETE && ost.DL_BACKAMT<>0 && ost.DT_PREBACKD<>0
			GROUP BY
				case when ost.DT_ACAMTD is not null and ost.DT_PREBACKD>ost.DT_ACAMTD then DATE_FORMAT(ost.DT_ACAMTD,'%Y%m') else DATE_FORMAT(ost.DT_PREBACKD,'%Y%m') end,
				I_PROTNAME
) yrece on yrece.contid4 = cont.ID and yrece.yreceym = t.yearmonth

where cont.S_APPSTATUS = 1
/*
and 
	case 
	when S_CONTYPE = '01' then cont.DL_CONAMT 
	when S_CONTYPE = '02' then (SELECT SUM(DL_STATEMAMT) from mdl_aos_sastatem o where o.IS_DELETE = 0
and o.I_PROTNAME = cont.ID)
	else 0
	end is null
*/