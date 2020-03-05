SELECT 
sinout.projectno `项目编号`,
sinout.projectname `项目名称`,
sinout.deptname `项目所属部门`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'IDC1' and DICT_CODE = p.S_IDC1) `解决方案`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'IDC2' and DICT_CODE = p.S_IDC2) `解决子案2`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJSTATUS' and DICT_CODE = p.S_PRJSTATUS) `项目状态`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'OPERTYPE' and DICT_CODE = p.S_OPERTYPE) `操作类型`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'ApproStatus' and DICT_CODE = p.S_APPSTATUS) `审批状态`,
sinout.pmname `项目经理`,
sinout.pdname `项目总监`,
cust.S_CUSTNAME `客户名称`,
sale.REAL_NAME `销售代表`,
saleorg.s_name `销售大区`,
tec.REAL_NAME `客户经理`,
DATE_FORMAT(sinout.predictstartdate,'%Y-%m-%d') `项目开始日期`,
DATE_FORMAT(sinout.predictenddate,'%Y-%m-%d') `项目结束日期`,
DATE_FORMAT(sinout.maintenancedate,'%Y-%m-%d') `项目维保期`,
sinout.predictcost `预算总成本`,
sinout.projectamout `立项金额`,

IFNULL(jan_rlcb,0)+IFNULL(feb_rlcb,0)+IFNULL(mar_rlcb,0)+IFNULL(apr_rlcb,0)+IFNULL(may_rlcb,0)+IFNULL(jun_rlcb,0)+IFNULL(jul_rlcb,0)+IFNULL(aug_rlcb,0)+IFNULL(sep_rlcb,0)+IFNULL(oct_rlcb,0)+IFNULL(nov_rlcb,0)+IFNULL(dec_rlcb,0) `本年人力成本`,
IFNULL(jan_sjfy,0)+IFNULL(feb_sjfy,0)+IFNULL(mar_sjfy,0)+IFNULL(apr_sjfy,0)+IFNULL(may_sjfy,0)+IFNULL(jun_sjfy,0)+IFNULL(jul_sjfy,0)+IFNULL(aug_sjfy,0)+IFNULL(sep_sjfy,0)+IFNULL(oct_sjfy,0)+IFNULL(nov_sjfy,0)+IFNULL(dec_sjfy,0) `本年费用`,
IFNULL(jan_cgcb,0)+IFNULL(feb_cgcb,0)+IFNULL(mar_cgcb,0)+IFNULL(apr_cgcb,0)+IFNULL(may_cgcb,0)+IFNULL(jun_cgcb,0)+IFNULL(jul_cgcb,0)+IFNULL(aug_cgcb,0)+IFNULL(sep_cgcb,0)+IFNULL(oct_cgcb,0)+IFNULL(nov_cgcb,0)+IFNULL(dec_cgcb,0) `本年采购`,

IFNULL(jan_rlcb,0) `一月人力成本`,
IFNULL(feb_rlcb,0) `二月人力成本`,
IFNULL(mar_rlcb,0) `三月人力成本`,
IFNULL(apr_rlcb,0) `四月人力成本`,
IFNULL(may_rlcb,0) `五月人力成本`,
IFNULL(jun_rlcb,0) `六月人力成本`,
IFNULL(jul_rlcb,0) `七月人力成本`,
IFNULL(aug_rlcb,0) `八月人力成本`,
IFNULL(sep_rlcb,0) `九月人力成本`,
IFNULL(oct_rlcb,0) `十月人力成本`,
IFNULL(nov_rlcb,0) `十一月人力成本`,
IFNULL(dec_rlcb,0) `十二月人力成本`,

IFNULL(jan_sjfy,0) `一月费用`,
IFNULL(feb_sjfy,0) `二月费用`,
IFNULL(mar_sjfy,0) `三月费用`,
IFNULL(apr_sjfy,0) `四月费用`,
IFNULL(may_sjfy,0) `五月费用`,
IFNULL(jun_sjfy,0) `六月费用`,
IFNULL(jul_sjfy,0) `七月费用`,
IFNULL(aug_sjfy,0) `八月费用`,
IFNULL(sep_sjfy,0) `九月费用`,
IFNULL(oct_sjfy,0) `十月费用`,
IFNULL(nov_sjfy,0) `十一月费用`,
IFNULL(dec_sjfy,0) `十二月费用`,

IFNULL(jan_cgcb,0) `一月采购`,
IFNULL(feb_cgcb,0) `二月采购`,
IFNULL(mar_cgcb,0) `三月采购`,
IFNULL(apr_cgcb,0) `四月采购`,
IFNULL(may_cgcb,0) `五月采购`,
IFNULL(jun_cgcb,0) `六月采购`,
IFNULL(jul_cgcb,0) `七月采购`,
IFNULL(aug_cgcb,0) `八月采购`,
IFNULL(sep_cgcb,0) `九月采购`,
IFNULL(oct_cgcb,0) `十月采购`,
IFNULL(nov_cgcb,0) `十一月采购`,
IFNULL(dec_cgcb,0) `十二月采购`,

IFNULL(qc.`2019年期初成本`,0) `2019年期初成本`

FROM t_snap_projectinfoinout sinout
LEFT JOIN mdl_aos_project p on sinout.projectid = p.id
left join mdl_aos_sapnotify nify on nify.ID = p.I_PRJNOTICE
left join mdl_aos_sapoinf buz on buz.ID = nify.I_POID
left join mdl_aos_sacustinf cust on cust.ID = buz.I_CUSTID
left join plf_aos_auth_user tec on tec.ID = buz.owner_id
left join plf_aos_auth_user sale on sale.ID = cust.S_SALEOWNER
left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = left(sale.ORG_CODE,13)
left join (
	SELECT
		projectno,yearmonth,cumulativecost `2019年期初成本`
	FROM t_snap_income_projectinfo
	WHERE yearmonth = '201812'
	GROUP BY projectid
)qc on qc.projectno = p.s_prjno
WHERE p.IS_DELETE = 0  AND p.S_PRJTYPE = 'YY'  AND p.S_PRJSTATUS <> '01'
{项目编号}{项目经理}