SELECT 
	S_CONCODE `合同编号`,
	S_CONNAME `合同名称`,
	ApproStatus.dict_name `审批状态`,
	CONSTATUS.dict_name `合同状态`,
	IFNULL(PROTCATE.dict_name,cate.dict_name) `合同类型`,
	cust.S_CUSTNAME `甲方`, partyb.S_NAME `乙方`,
	tec1.REAL_NAME `客户经理A`, tec2.REAL_NAME `客户经理B`,
	po.S_POCODE `所属项目商机编号`, po.S_PONAME `所属项目商机名称`,
	DATE_FORMAT(cont.DT_BEGDATE,'%Y-%m-%d') `合同开始日期`,
	DATE_FORMAT(cont.DT_ENDDATE,'%Y-%m-%d') `合同结束日期`,
	DATE_FORMAT(cont.DT_PSIGNDATE,'%Y-%m-%d') `预计签约日期`,
	DATE_FORMAT(cont.DT_ASIGNDATE,'%Y-%m-%d') `实际签约日期`,
	DATE_FORMAT(DT_FILEDATE,'%Y-%m-%d') `归档日期`,
	cont.DL_CONAMT `合同额`,
	constag.*
from mdl_aos_sacont cont
left join (
-- 固定金额开票回款
	SELECT
		I_CONID,
-- 		GROUP_CONCAT(S_STAGEDES) `阶段名称`,
		SUM(DL_BILLAMT) `预开金额`,
		SUM(DL_BACKAMT) `预回金额`,
		SUM(DL_ACBILLAMT) `实开金额`,
		SUM(DL_ACBACKAMT) `实回金额`,
		SUM(DL_ASSAMT) `已分配金额`
	from mdl_aos_saconstag
	GROUP BY I_CONID

	union all
-- 结算单开票回款
	SELECT
		I_PROTNAME,
-- 		GROUP_CONCAT(S_STACODE) `结算单编号`,
		SUM(ost.DL_BILLAMT) `预开金额`,
		SUM(ost.DL_BACKAMT) `预回金额`,
		SUM(ost.DL_ACBACKAMT) `实开金额`,
		SUM(ost.DL_ACBACKAMT) `实回金额`
	from mdl_aos_sastatem o
	left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
	GROUP BY o.I_PROTNAME

) constag on constag.I_CONID = cont.ID
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