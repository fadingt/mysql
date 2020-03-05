SELECT
	poinf.S_POCODE `项目商机编号`, poinf.s_poname `项目商机名称`,
	POSTAGE.dict_name `项目商机阶段`,SIGNRATE.dict_name `签约可能性`,
	cust.S_CUSTNAME `客户名称`,
	DATE_FORMAT(poinf.DT_PREBEGD,'%Y-%m-%d') `预计立项日期`,
	DATE_FORMAT(poinf.DT_PREENDD,'%Y-%m-%d') `预计结束日期`,
	DL_SUMAMT `项目商机金额`, DL_SUMFEE `项目商机费用总额`, DL_SUMDAYAMT `项目商机人天预算总额`,
	GROUP_CONCAT(p.S_PRJNO) `关联项目编号`,
	COUNT(case when p.IS_DELETE =0 and p.DT_SETUPTIME is not null then p.ID end) `已立项数量`,
	SUM(case when p.IS_DELETE =0 and p.DT_SETUPTIME is not null then p.DL_BUDCOAMTI else 0 end) `已立项金额`
from MDL_AOS_SAPOINF poinf
left join mdl_aos_sapnotify note on note.I_POID = poinf.ID
left join mdl_aos_project p on p.I_PRJNOTICE = note.ID
left join mdl_aos_sacustinf cust on cust.ID = poinf.I_CUSTID
left join plf_aos_auth_user tec1 on tec1.ID = cust.S_FIRTECH
join (
	SELECT *
	from plf_aos_auth_org 
	where ORG_CODE = '0001001027'
)tec1org on tec1org.ORG_CODE = left(tec1.ORG_CODE,10)

left join (SELECT *from plf_aos_dictionary where DICT_TYPE = 'POSTAGE') POSTAGE on POSTAGE.dict_code = poinf.S_POSTAGE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'SIGNRATE') SIGNRATE on SIGNRATE.dict_code = poinf.S_SIGNRATE
where poinf.S_APPSTATUS = 1 and poinf.IS_DELETE = 0
group BY poinf.ID