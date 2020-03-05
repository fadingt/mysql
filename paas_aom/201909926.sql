
SELECT 
p.S_PRJNO `项目编号`,
p.S_PRJNAME `项目名称`,
case LENGTH(p.S_DEPT) when 13 then org1.S_NAME when 16 then CONCAT(org1.S_NAME,'-',org2.S_NAME) end `项目所属部门`,
-- prjclass.DICT_NAME `项目分类`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'IDC1' and DICT_CODE = p.S_IDC1) `解决方案`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'IDC2' and DICT_CODE = p.S_IDC2) `解决子案2`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJSTATUS' and DICT_CODE = p.S_PRJSTATUS) `项目状态`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'OPERTYPE' and DICT_CODE = p.S_OPERTYPE) `操作类型`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'ApproStatus' and DICT_CODE = p.S_APPSTATUS) `审批状态`,
pm.REAL_NAME `项目经理`,
pd.REAL_NAME `项目总监`,
cust.S_CUSTNAME `客户名称`,
sale.REAL_NAME `销售代表`,
saleorg.s_name `销售大区`,
tec.REAL_NAME `客户经理`,
DATE_FORMAT(p.DT_STARTTIME,'%Y-%m-%d') `项目开始日期`,
DATE_FORMAT(p.DT_ENDTIME,'%Y-%m-%d') `项目结束日期`,
DATE_FORMAT(p.DT_MAINEND,'%Y-%m-%d') `项目维保期`,
p.DL_BUDTOLCOS `预算总成本`,
p.DL_BUDCOAMTI `立项金额`,
IFNULL(rlcb1,0)+IFNULL(rlcb2,0)+IFNULL(rlcb3,0)+IFNULL(rlcb4,0)+IFNULL(rlcb5,0)+IFNULL(rlcb6,0)+IFNULL(rlcb7,0)+IFNULL(rlcb8,0)+IFNULL(rlcb9,0)+IFNULL(rlcb10,0)+IFNULL(rlcb11,0)+IFNULL(rlcb12,0) `本年人力成本`,
IFNULL(sjfy1,0)+IFNULL(sjfy2,0)+IFNULL(sjfy3,0)+IFNULL(sjfy4,0)+IFNULL(sjfy5,0)+IFNULL(sjfy6,0)+IFNULL(sjfy7,0)+IFNULL(sjfy8,0)+IFNULL(sjfy9,0)+IFNULL(sjfy10,0)+IFNULL(sjfy11,0)+IFNULL(sjfy12,0) `本年费用`,
IFNULL(cgcb1,0)+IFNULL(cgcb2,0)+IFNULL(cgcb3,0)+IFNULL(cgcb4,0)+IFNULL(cgcb5,0)+IFNULL(cgcb6,0)+IFNULL(cgcb7,0)+IFNULL(cgcb8,0)+IFNULL(cgcb9,0)+IFNULL(cgcb10,0)+IFNULL(cgcb11,0)+IFNULL(cgcb12,0) `本年采购`,

IFNULL(rlcb1,0) `一月人力成本`,
IFNULL(rlcb2,0) `二月人力成本`,
IFNULL(rlcb3,0) `三月人力成本`,
IFNULL(rlcb4,0) `四月人力成本`,
IFNULL(rlcb5,0) `五月人力成本`,
IFNULL(rlcb6,0) `六月人力成本`,
IFNULL(rlcb7,0) `七月人力成本`,
IFNULL(rlcb8,0) `八月人力成本`,
IFNULL(rlcb9,0) `九月人力成本`,
IFNULL(rlcb10,0) `十月人力成本`,
IFNULL(rlcb11,0) `十一月人力成本`,
IFNULL(rlcb12,0) `十二月人力成本`,

IFNULL(sjfy1,0) `一月费用`,
IFNULL(sjfy2,0) `二月费用`,
IFNULL(sjfy3,0) `三月费用`,
IFNULL(sjfy4,0) `四月费用`,
IFNULL(sjfy5,0) `五月费用`,
IFNULL(sjfy6,0) `六月费用`,
IFNULL(sjfy7,0) `七月费用`,
IFNULL(sjfy8,0) `八月费用`,
IFNULL(sjfy9,0) `九月费用`,
IFNULL(sjfy10,0) `十月费用`,
IFNULL(sjfy11,0) `十一月费用`,
IFNULL(sjfy12,0) `十二月费用`,

IFNULL(cgcb1,0) `一月采购`,
IFNULL(cgcb2,0) `二月采购`,
IFNULL(cgcb3,0) `三月采购`,
IFNULL(cgcb4,0) `四月采购`,
IFNULL(cgcb5,0) `五月采购`,
IFNULL(cgcb6,0) `六月采购`,
IFNULL(cgcb7,0) `七月采购`,
IFNULL(cgcb8,0) `八月采购`,
IFNULL(cgcb9,0) `九月采购`,
IFNULL(cgcb10,0) `十月采购`,
IFNULL(cgcb11,0) `十一月采购`,
IFNULL(cgcb12,0) `十二月采购`,

IFNULL(qc.`2019年期初成本`,0) `2019年期初成本`
from mdl_aos_project p
left join mdl_aos_sapnotify note on p.I_PRJNOTICE = note.ID
left join mdl_aos_sapoinf poinf on note.I_POID = poinf.ID

left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
left join plf_aos_auth_user pd on pd.ID = p.S_DIRECTOR
left join mdl_aos_hrorg org1 on org1.S_ORGCODE = left(p.S_DEPT,13)
left join mdl_aos_hrorg org2 on org2.S_ORGCODE = left(p.S_DEPT,16)
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

left join (
		SELECT budgetno,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'01') then  debit else 0 end,0) )sjfy1,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'02') then  debit else 0 end,0) )sjfy2,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'03') then  debit else 0 end,0) )sjfy3,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'04') then  debit else 0 end,0) )sjfy4,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'05') then  debit else 0 end,0) )sjfy5,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'06') then  debit else 0 end,0) )sjfy6,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'07') then  debit else 0 end,0) )sjfy7,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'08') then  debit else 0 end,0) )sjfy8,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'09') then  debit else 0 end,0) )sjfy9,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'10') then  debit else 0 end,0) )sjfy10,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'11') then  debit else 0 end,0) )sjfy11,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'12') then  debit else 0 end,0) )sjfy12
		FROM t_snap_fi_voucher
		where yearmonth is not null and zzno = '6401' and budgetno like 'yy%' and dc='01'
			and busitype not in (22002,27001,23002,24002,28002)
			and mxno not in (640133,640134)
		GROUP BY budgetno
)realfee on realfee.budgetno = p.s_prjno

left join (
		SELECT budgetno,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'01') then  debit else 0 end,0) )cgcb1,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'02') then  debit else 0 end,0) )cgcb2,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'03') then  debit else 0 end,0) )cgcb3,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'04') then  debit else 0 end,0) )cgcb4,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'05') then  debit else 0 end,0) )cgcb5,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'06') then  debit else 0 end,0) )cgcb6,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'07') then  debit else 0 end,0) )cgcb7,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'08') then  debit else 0 end,0) )cgcb8,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'09') then  debit else 0 end,0) )cgcb9,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'10') then  debit else 0 end,0) )cgcb10,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'11') then  debit else 0 end,0) )cgcb11,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'12') then  debit else 0 end,0) )cgcb12
		FROM t_snap_fi_voucher
		where yearmonth is not null and zzno = '6401' and budgetno like 'yy%' and dc='01'
			and busitype not in (22002,27001,23002,24002,28002)
			and mxno in (140501,140502,14050333,14050334,640133,640134)
		GROUP BY budgetno
)pur on pur.budgetno = p.s_prjno

left join (
		SELECT budgetno,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'01') then  amt else 0 end,0) )rlcb1,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'02') then  amt else 0 end,0) )rlcb2,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'03') then  amt else 0 end,0) )rlcb3,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'04') then  amt else 0 end,0) )rlcb4,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'05') then  amt else 0 end,0) )rlcb5,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'06') then  amt else 0 end,0) )rlcb6,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'07') then  amt else 0 end,0) )rlcb7,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'08') then  amt else 0 end,0) )rlcb8,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'09') then  amt else 0 end,0) )rlcb9,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'10') then  amt else 0 end,0) )rlcb10,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'11') then  amt else 0 end,0) )rlcb11,
		sum(ifnull(case when yearmonth=CONCAT(year(NOW()),'12') then  amt else 0 end,0) )rlcb12
		FROM t_snap_fi_standardcost
		where isactingstd = 1 and budgetno like 'YY%' and account = '6401'
		GROUP BY budgetno
)cost on cost.budgetno = p.s_prjno

WHERE p.IS_DELETE = 0  AND p.S_PRJTYPE = 'YY'  AND p.S_PRJSTATUS <> '01'
{项目编号}{项目经理}