SELECT 
	coinf.ID, coinf.I_CUSTID, coinf.S_COCODE `客户商机编号`, S_CONAME `客户商机名称`, DATE_FORMAT(DT_YEARR,'%Y') `客户商机年份`, DL_PRESIGAMT `客户商机预计签约金额`,
	ApproStatus.dict_name `客户商机审批状态`,
sale.REAL_NAME `客户商机销售负责人`,
ngoss.getusername(cust.S_FIRTECH) `客户经理`,
salearea.S_NAME `销售所属区域`,
cust.S_CUSTNAME `客户名称`,
poinf.*
from mdl_aos_sacoinf coinf
left join mdl_aos_sacustinf cust on cust.ID = coinf.I_CUSTID
left join ( 
	SELECT 
		I_COID, S_POCODE `项目商机编号`, S_PONAME `项目商机名称`, DL_SUMAMT `项目商机预计总价`,
		DT_PREBEGD `预计开始日期`, DT_PREENDD `预计结束日期`,
		ngoss.translatedict('SIGNRATE',S_SIGNRATE) `签约可能性`,
		ngoss.translatedict('POSTAGE',S_POSTAGE) `商机阶段`
	from mdl_aos_sapoinf
	WHERE S_APPSTATUS =1 and IS_DELETE = 0 and I_COID is not null
)poinf on poinf.I_COID = coinf.ID

left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.dict_code = coinf.S_APPSTATUS
left join plf_aos_auth_user sale on sale.ID = coinf.S_SALEOWNER
left join mdl_aos_hrorg salearea on salearea.S_ORGCODE = left(sale.ORG_CODE,13)
where coinf.IS_DELETE = 0