SELECT 
nowyear `年份`,
a.projectno `项目编号`,
a.projectname `项目名称`,
a.deptname `项目所属部门`,
p.`解决方案`,
p.`解决子案2`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJSTATUS' and DICT_CODE = a.projstatus) `项目状态`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'OPERTYPE' and DICT_CODE = a.opertype) `操作类型`,
-- (SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'ApproStatus' and DICT_CODE = p.S_APPSTATUS) `审批状态`,
a.pmname `项目经理`,
a.pdname `项目总监`,
p.`客户名称`,
p.`销售代表`,
p.`销售大区`,
p.`客户经理`,
DATE_FORMAT(a.predictstartdate,'%Y-%m-%d') `项目开始日期`,
DATE_FORMAT(a.predictenddate,'%Y-%m-%d') `项目结束日期`,
DATE_FORMAT(a.maintenancedate,'%Y-%m-%d') `项目维保期`,
a.predictcost `预算总成本`,
a.projectamout `立项金额`,

jan_rlcb+feb_rlcb+mar_rlcb+apr_rlcb+may_rlcb+jun_rlcb+jul_rlcb+aug_rlcb+sep_rlcb+oct_rlcb+nov_rlcb+dec_rlcb `本年人力成本`,
jan_sjfy+feb_sjfy+mar_sjfy+apr_sjfy+may_sjfy+jun_sjfy+jul_sjfy+aug_sjfy+sep_sjfy+oct_sjfy+nov_sjfy+dec_sjfy `本年费用`,
jan_cgcb+feb_cgcb+mar_cgcb+apr_cgcb+may_cgcb+jun_cgcb+jul_cgcb+aug_cgcb+sep_cgcb+oct_cgcb+nov_cgcb+dec_cgcb `本年采购`,

jan_rlcb `一月人力成本`,
feb_rlcb `二月人力成本`,
mar_rlcb `三月人力成本`,
apr_rlcb `四月人力成本`,
may_rlcb `五月人力成本`,
jun_rlcb `六月人力成本`,
jul_rlcb `七月人力成本`,
aug_rlcb `八月人力成本`,
sep_rlcb `九月人力成本`,
oct_rlcb `十月人力成本`,
nov_rlcb `十一月人力成本`,
dec_rlcb `十二月人力成本`,

jan_sjfy `一月费用`,
feb_sjfy `二月费用`,
mar_sjfy `三月费用`,
apr_sjfy `四月费用`,
may_sjfy `五月费用`,
jun_sjfy `六月费用`,
jul_sjfy `七月费用`,
aug_sjfy `八月费用`,
sep_sjfy `九月费用`,
oct_sjfy `十月费用`,
nov_sjfy `十一月费用`,
dec_sjfy `十二月费用`,

jan_cgcb `一月采购`,
feb_cgcb `二月采购`,
mar_cgcb `三月采购`,
apr_cgcb `四月采购`,
may_cgcb `五月采购`,
jun_cgcb `六月采购`,
jul_cgcb `七月采购`,
aug_cgcb `八月采购`,
sep_cgcb `九月采购`,
oct_cgcb `十月采购`,
nov_cgcb `十一月采购`,
dec_cgcb `十二月采购`,
IFNULL(qc.`2019年期初成本`,0) `2019年期初成本`
from t_snap_projectinfoinout a
left join (
	SELECT
		projectno,yearmonth,cumulativecost `2019年期初成本`
	FROM t_snap_income_projectinfo
	WHERE yearmonth = '201812'
	GROUP BY projectid
)qc on qc.projectno = a.projectno
left join (
	SELECT 
	p.ID,
	(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'IDC1' and DICT_CODE = p.S_IDC1) `解决方案`,
	(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'IDC2' and DICT_CODE = p.S_IDC2) `解决子案2`,
	cust.S_CUSTNAME `客户名称`,
	sale.REAL_NAME `销售代表`,
	saleorg.s_name `销售大区`,
	tec.REAL_NAME `客户经理`
	from mdl_aos_project p
	left join mdl_aos_sapnotify nify on nify.ID = p.I_PRJNOTICE
	left join mdl_aos_sapoinf buz on buz.ID = nify.I_POID
	left join mdl_aos_sacustinf cust on cust.ID = buz.I_CUSTID
	left join plf_aos_auth_user tec on tec.ID = buz.owner_id
	left join plf_aos_auth_user sale on sale.ID = buz.S_SALEMAN
	left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = left(sale.ORG_CODE,13)
	where p.S_PRJTYPE = 'yy' and p.IS_DELETE = 0
)p on a.projectid = p.id
where {项目编号}{项目经理}{年份}