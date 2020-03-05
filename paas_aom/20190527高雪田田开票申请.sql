-- (01-合同阶段开票;02-无合同开票;03-框架协议开票;04-退票;05-开票)
SELECT
cont.S_CONCODE `合同编号`, cont.S_CONNAME `合同名称`,
comp.S_COMPNAME `财务主体`,
-- billapp.S_FINANCE `财务主体2`,
-- stage.type,
stage.`结算单编号/合同阶段`,

billapp.ID as billappid,
billapp.S_BILLCODE `开票编号`,`owner`.REAL_NAME `开票申请人`,billapp.CREATE_TIME `开票申请日期`,
billapp.DL_HASBILL `开票金额`,billapp.DL_TAXAMT `开票税金`,
(billapp.DL_HASBILL- billapp.DL_TAXAMT) `开票不含税金额`,
taxrate.diCt_name `开票申请税率`,billapp.S_TAXRATE,
BilType.dict_name `开票类型`, BILLSTATUS.dict_name `开票状态`, BACKSTA.dict_name `回款状态`,
ApproStatus.dict_name `开票申请审批状态`,
bill.*,
BOUNCE.*
FROM mdl_aos_sabillapp billapp
LEFT JOIN mdl_aos_fibilmain main ON billapp.ID = main.I_BILLAPPID
LEFT JOIN (
SELECT
I_MAINID,S_BILLNUM `发票号`, S_BILLCONT `发票内容`,DT_BILLDATE `发票日期`,CREATE_TIME 发票登记日期,
(DL_AMOUNT)  `发票金额`,(DL_TAXAMOUNT) `发票税额`,
S_TAXRATE taxrate1
FROM mdl_aos_fibill
where IS_DELETE = 0 and I_MAINID is not null
-- GROUP BY I_MAINID
) bill ON main.ID = bill.I_MAINID
left join (
			SELECT
				I_CONID, '固定金额' type, CONCAT(ID,'/',S_STAGEDES) `结算单编号/合同阶段`, I_BILLID, I_BOUNCEID,
				DL_ACBILLAMT, DATE_FORMAT(DT_ACBILLD,'%Y%m') DT_ACBILLD, -- 实开
				DL_ACBACKAMT, DATE_FORMAT(DT_ACAMTD,'%Y%m') DT_ACAMTD,-- 实回
				DL_BILLAMT, 
				case when DT_ACBILLD is not null and DT_PREBILLD>DT_ACBILLD  then DATE_FORMAT(DT_ACBILLD,'%Y%m') else DATE_FORMAT(DT_PREBILLD,'%Y%m') end as DT_PREBILLD,-- 预开
				DL_BACKAMT, 
				case when DT_ACAMTD is not null and DT_PREBACKD>DT_ACAMTD then DATE_FORMAT(DT_ACAMTD,'%Y%m') else DATE_FORMAT(DT_PREBACKD,'%Y%m') end as DT_PREBACKD-- 预回 
			from mdl_aos_saconstag
			where !IS_DELETE
			union all
			SELECT
				I_PROTNAME, '框架协议', o.S_STACODE, ost.I_BILLID, ost.I_BOUNCEID,
				ost.DL_ACBILLAMT, DATE_FORMAT(ost.DT_ACBILLD,'%Y%m'),
				ost.DL_ACBACKAMT, DATE_FORMAT(ost.DT_ACAMTD,'%Y%m'),
				ost.DL_BILLAMT, 
				case when ost.DT_ACBILLD is not null and ost.DT_PREBILLD>ost.DT_ACBILLD then DATE_FORMAT(ost.DT_ACBILLD,'%Y%m') else DATE_FORMAT(ost.DT_PREBILLD,'%Y%m') end,
				ost.DL_BACKAMT, 
				case when ost.DT_ACAMTD is not null and ost.DT_PREBACKD>ost.DT_ACAMTD then DATE_FORMAT(ost.DT_ACAMTD,'%Y%m') else DATE_FORMAT(ost.DT_PREBACKD,'%Y%m') end
			from mdl_aos_sastatem o
			left join mdl_aos_saorderst ost on o.id = ost.I_STATEID
			where !ost.IS_DELETE && !o.IS_DELETE
)stage on stage.I_BILLID = billapp.ID
left join (
	SELECT 
		ID,S_BOUNCENO `退票单号`, S_BOUNTYPE `退票类型`,
		DL_BOUNCEAMT `退票含税金额`, DL_BOUNCETAX `退票税金`, DL_ACBOUNAMT `退票不含税金额`,
		S_REMARK `退票说明`, S_STAGEID
	FROM `mdl_aos_sabounce`
	where IS_DELETE = 0 and S_APPSTATUS = 1
)BOUNCE on BOUNCE.id = stage.I_BOUNCEID
left join mdl_aos_sacont cont on cont.ID = billapp.I_CONID
left join mdl_aos_compcode comp on comp.ID = cont.S_PARTYB
left join plf_aos_auth_user owner on owner.ID = billapp.OWNER_ID
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.dict_code = billapp.S_APPSTATUS
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BilType')BilType on BilType.dict_code = billapp.S_BILLTYPE
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BILLTYPE')BILLTYPE on BILLTYPE.dict_code = billapp.S_BILLFORM
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BACKSTA')BACKSTA on BACKSTA.dict_code = billapp.S_BACKSTA
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BILLSTATUS')BILLSTATUS on BILLSTATUS.dict_code = billapp.S_BILLSTA
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'taxrate') taxrate on taxrate.dict_code = billapp.S_TAXRATE
-- left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'taxrate') taxrate2 on taxrate2.dict_code = bill.S_TAXRATE
WHERE billapp.IS_DELETE = 0 AND main.IS_DELETE = 0