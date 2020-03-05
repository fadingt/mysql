/*
开票类型	财务主体	发票抬头	
发票类型	发票申请时间	所属销售	发票申请操作类型	
录入发票状态	录入发票时间	 发票编号	发票内容	发票时间	发票金额（含税)	发票金额（不含税）	
发票状态	对应项目编号	项目名称	项目阶段	项目阶段预开	项目阶段预开日期	
*/
SELECT
	billapp.ID,
	tradeif.S_SRCNUM `开票编号`, cont.S_CONCODE `合同编号`, cont.S_CONNAME `合同名称`,
	BILLSTATUS.dict_name `开票状态`, BACKSTA.dict_name `回款状态`,BilType.dict_name `开票类型`, company.ORG_NAME `财务主体`,
-- billapp.S_FINANCE `财务主体`,
billapp.DL_ABILLAMT `开票申请金额（不含税）`, DL_HASBILL `开票申请金额（含税）`,
bill.DL_AMOUNT `开票金额(含税)`, (bill.DL_AMOUNT-bill.DL_TAXAMOUNT) `开票金额(不含税)`,
BILLTYPE.dict_name `发票类型`, billapp.DT_BILLDATE `发票申请日期`, sale.REAL_NAME `所属销售`,
billapp.OPERATION_TYPE `发票申请操作类型`,
-- tradeif.DT_RCDDATE `分录日期`,
bill.S_BILLNUM `发票号`, bill.S_BILLCONT `发票内容`,bill.DT_BILLDATE `发票日期`, bill.DL_AMOUNT `发票金额`,
   bill.CREATE_TIME 发票登记日期,
-- bill.I_BOUNCEID `退票id`, bill.S_OLDBILLNO `原发票编号`,
tradeif.S_PROJECTNB `对应项目编号`, tradeif.S_PRONAME `项目名称`
from mdl_aos_sabillapp billapp
left join (SELECT * from mdl_aos_fitradeif where IS_DELETE = 0)tradeif on tradeif.S_BILAPLYID =billapp.ID
left join (SELECT * from mdl_aos_fibill where IS_DELETE = 0)bill on bill.S_FITRADEID = tradeif.ID
-- left join mdl_aos_sabounce bounce on bounce.ID = bill.I_BOUNCEID
left join mdl_aos_sacont cont on cont.ID = billapp.I_CONID
left join plf_aos_auth_user sale on sale.ID = billapp.OWNER_ID
left join plf_aos_auth_org company on company.ID = tradeif.S_FINANCODE

left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BilType')BilType on BilType.dict_code = billapp.S_BILLTYPE
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BILLTYPE')BILLTYPE on BILLTYPE.dict_code = billapp.S_BILLFORM
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BACKSTA')BACKSTA on BACKSTA.dict_code = billapp.S_BACKSTA
left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'BILLSTATUS')BILLSTATUS on BILLSTATUS.dict_code = billapp.S_BILLSTA

where 1=1
and billapp.S_APPSTATUS = 1 and billapp.IS_DELETE = 0