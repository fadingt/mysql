SELECT
-- 	I_PROVINCE, I_CITYID,
-- cust.S_APPSTATUS,S_CUSSTATUS, -- 审批状态 启用状态
cust.ID, S_CUSTNAME `客户名称`,
S_SHORTNAME `客户简称`, S_CUSTADDR `客户所在地`,
tec.tecC `C条线`,
tec.tecD 'D条线',
tec.tecO `O条线`,
DEVREGION.dict_name `开发区域`,
sale.REAL_NAME `销售代表`,region.dict_name `销售区域`, 
-- salearea.S_NAME `销售代表所属区域`,
saleunit.s_name `销售所属部门`,
-- co.S_COCODE `客户商机编号`,
-- co.S_CONAME `客户商机名称`,
-- IFNULL(co.DL_SUMDAYAMT,0) `预计人力`,
-- IFNULL(co.DL_PREFEE,0) `预计费用`,
-- co.DL_PRESIGAMT `客户商机预计签约金额`,
-- coto.S_COCODE `待审核客户商机编号`,
-- coto.S_CONAME `待审核客户商机名称`,

COPERTYPE.dict_name `客户操作类型`
from mdl_aos_sacustinf cust
-- left join (
-- 	SELECT I_CUSTID, S_COCODE, S_CONAME, DL_PREFEE, DL_SUMDAYAMT, DL_PRESIGAMT
-- 	from mdl_aos_sacoinf
-- 	where DATE_FORMAT(DT_YEARR,'%Y') = 2019 and S_APPSTATUS = 1
-- ) co on co.I_CUSTID = cust.ID
-- left join (
-- 	SELECT I_CUSTID, S_COCODE, S_CONAME
-- 	from mdl_aos_sacoinf
-- 	where DATE_FORMAT(DT_YEARR,'%Y') = 2019 and S_APPSTATUS =2
-- ) coto on coto.I_CUSTID = cust.ID
left join plf_aos_auth_user sale on sale.ID = cust.S_SALEOWNER
left join (
	SELECT 
		case a.S_DEPTL when 'D' then b.REAL_NAME END as tecD,
		case a.S_DEPTL when 'C' then b.REAL_NAME END as tecC,
		case a.S_DEPTL when 'O' then b.REAL_NAME END as tecO,
I_CUSTID
	FROM `mdl_aos_sacusttech` a
	left join plf_aos_auth_user b on a.S_TECHID = b.ID
	GROUP BY I_CUSTID
)tec on tec.I_CUSTID = cust.ID
left join (SELECT * from plf_aos_dictionary where dict_type = 'positwh') region on region.dict_code = cust.S_REGION
left join (SELECT * from plf_aos_dictionary where dict_type = 'positwh') DEVREGION on DEVREGION.dict_code = cust.S_DEVREGION
-- left join mdl_aos_hrorg tec1area on left(tec1.ORG_CODE,13) = tec1area.S_ORGCODE
left join mdl_aos_hrorg saleunit on sale.ORG_CODE = saleunit.S_ORGCODE
-- left join mdl_aos_hrorg tec1unit on tec1.ORG_CODE = tec1unit.S_ORGCODE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE like 'COPERTYPE') COPERTYPE on COPERTYPE.dict_code = cust.S_OPERTYPE
where cust.S_CUSSTATUS = 1 and cust.S_APPSTATUS = 1