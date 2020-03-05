SELECT 
coinf.ID, coinf.I_CUSTID, coinf.S_COCODE `客户商机编号`, S_CONAME `客户商机名称`, DATE_FORMAT(DT_YEARR,'%Y') `客户商机年份`, 
DL_PRESIGAMT `客户商机金额`,
IFNULL(poinf.poamt,0) `已立项目商机总金额`, 
IFNULL(pinf.pamt,0)`已立项目总金额`,
	ApproStatus.dict_name `客户商机审批状态`,
sale.REAL_NAME `销售代表`,
salearea.S_NAME `销售所属区域`,
IFNULL(poinf.pocnt,0) `转项目商机数`,
IFNULL(pinf.pcnt,0) `已立项数`,
cust.S_CUSTNAME `客户名称`,
teca.REAL_NAME `客户经理A`,
ngoss.getfullorgname(teca.ORG_CODE) `客户经理A所属部门`,
tecb.real_name `客户经理B`

from mdl_aos_sacoinf coinf
left join mdl_aos_sacustinf cust on cust.ID = coinf.I_CUSTID
left join (
	SELECT I_COID, SUM(DL_SUMAMT) poamt, COUNT(DISTINCT S_POCODE) pocnt
	from mdl_aos_sapoinf
	WHERE 1=1
	and IS_DELETE = 0 and I_COID is not null
	and !(S_APPSTATUS<>1 and S_OPERTYPE='001')
	AND (S_POSTAGE <> 6 AND S_POSTAGE <> 7 and S_POSTAGE <> 12) 
	GROUP BY I_COID
)poinf on poinf.I_COID = coinf.ID
left join (
	SELECT 
		poinf.I_COID, SUM(p.DL_BUDCOAMTI) pamt, COUNT(DISTINCT p.ID) pcnt
	from mdl_aos_sapoinf poinf
	left join mdl_aos_sapnotify note on note.I_POID = poinf.ID
	left join mdl_aos_project p on p.I_PRJNOTICE = note.ID
	WHERE 1=1
		and poinf.IS_DELETE = 0 and poinf.I_COID is not null
		and poinf.S_POSTAGE <> 6 and poinf.s_postage <> 7 and poinf.S_POSTAGE <> 12
		and note.IS_DELETE = 0
		and p.IS_DELETE = 0 and p.S_PRJSTATUS <> '01'
	GROUP BY I_COID
)pinf on pinf.I_COID = coinf.ID
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.dict_code = coinf.S_APPSTATUS
left join plf_aos_auth_user sale on sale.ID = coinf.S_SALEOWNER
left join mdl_aos_hrorg salearea on salearea.S_ORGCODE = left(sale.ORG_CODE,13)
left join plf_aos_auth_user teca on teca.ID = cust.S_FIRTECH
left join plf_aos_auth_user tecb on tecb.ID = cust.S_SECTECH
where coinf.IS_DELETE = 0
-- and coinf.S_COCODE not in (SELECT S_COCODE FROM `mdl_aos_sacoinfrf`)