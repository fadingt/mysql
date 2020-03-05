 SELECT
poinf.S_POCODE as `项目商机编号`,
-- poinf.DL_SUMFEE `预计费用总额`,
-- DL_OCCFEE `费用预算已占用金额`,
-- DL_ASSFEE `费用预算已分配金额`,
-- DL_UNASSFEE `费用预算未分配金额`,
-- poinf.DL_SUMFREFEE `费用已释放金额`,
poinf.DL_SUMDAYAMT `人天总额`,
DL_SUMFREAMT `人天已释放`,
DL_UNASSAMT `人天未分配`,
DL_ASSAMT `人天已分配`,
poinf.DL_OCCAMT `人天已占用`
from mdl_aos_sapoinf poinf
left join mdl_aos_sacoinf coinf on coinf.ID = poinf.I_COID
left join (
	SELECT
		SUM(p.DL_BUDCOAMTI) pamt, note.I_POID, COUNT(p.S_PRJNO) cnt
	from mdl_aos_project p
	left join mdl_aos_sapnotify note on p.I_PRJNOTICE = note.ID
	where 1=1
		and p.IS_DELETE = 0 and p.S_PRJSTATUS <> '01'
		and note.IS_DELETE = 0
	GROUP BY note.I_POID
)p on p.I_POID = poinf.ID
left join (
SELECT SUM(p.DL_BUDCOAMTI) DL_PROAMT, I_POID
from mdl_aos_sapnotify note
left join mdl_aos_project p on p.I_PRJNOTICE = note.ID
where 1=1 
and p.IS_DELETE = 0 and p.S_PRJSTATUS <> '01'
and note.IS_DELETE = 0
GROUP BY i_poid
) note on note.I_POID = poinf.ID
left join mdl_aos_sacustinf cust on cust.ID = coinf.I_CUSTID
left join mdl_aos_sacustinf pocust on pocust.ID = poinf.I_CUSTID
left join plf_aos_auth_user tec1 on tec1.ID = cust.S_FIRTECH
left join plf_aos_auth_user tec2 on tec2.ID = cust.S_SECTECH
left join plf_aos_auth_user sale on sale.ID = coinf.S_SALEOWNER
left join plf_aos_auth_org tec1area on tec1area.ORG_CODE = LEFT(tec1.org_code,13)
left join plf_aos_auth_org salearea on salearea.ORG_CODE = LEFT(sale.org_code,13)
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'POSTATUS') POSTATUS on POSTATUS.dict_code= poinf.S_POSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'POSTAGE') POSTAGE on POSTAGE.dict_code= poinf.S_POSTAGE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.dict_code= coinf.S_APPSTATUS

where poinf.IS_DELETE = 0
	AND ( poinf.S_APPSTATUS <> 4 OR poinf.S_OPERTYPE <> '001' ) 
	AND ( poinf.S_APPSTATUS <> 2 OR poinf.S_OPERTYPE <> '001' ) 
	AND ( poinf.S_APPSTATUS <> 3 OR poinf.S_OPERTYPE <> '001' ) 
	AND ( poinf.S_POSTAGE <> 6 AND poinf.S_POSTAGE <> 7 ) 
-- and DL_SUMFEE != DL_SUMFREFEE + DL_UNASSFEE + DL_ASSFEE + DL_OCCFEE
and poinf.DL_SUMDAYAMT != DL_SUMFREAMT + DL_UNASSAMT + DL_ASSAMT + poinf.DL_OCCAMT