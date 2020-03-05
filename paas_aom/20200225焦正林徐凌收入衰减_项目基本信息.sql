SELECT 
S_PRJNO `项目编号`, p.S_PRJNAME `项目名称`, 
cust.S_CUSTNAME `客户名称`,
getusername(poinf.OWNER_ID) `客户经理`, getusername(poinf.S_SALEMAN) `销售代表`,
p.DL_BUDCOAMTI `立项金额`,
p.DL_BUDTOLCOS `预算总成本`,p.DL_BUDCOSAMT `预算费用`, p.DL_BUDPURAMT `预算采购`, p.DL_BUDLABAMT `预算人力`,
DATE_FORMAT(DT_STARTTIME,'%Y-%m-%d') `开始日期`,
DATE_FORMAT(DT_ENDTIME,'%Y-%m-%d') `结束日期`,
DATE_FORMAT(DT_MAINEND,'%Y-%m-%d') `维保结束日期`
from mdl_aos_project p
left join mdl_aos_sapoinf poinf on p.I_POID = poinf.ID
left join mdl_aos_sacustinf cust on cust.id = poinf.I_CUSTID
where p.S_PRJTYPE = 'YY' and p.IS_DELETE = 0 and p.S_PRJSTATUS <> 06
and SUBSTRING(p.S_PRJNO FROM 4 FOR 4) BETWEEN 2018 and 2019