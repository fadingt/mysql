 SELECT
(SELECT GROUP_CONCAT(S_PRESCODE) from mdl_aos_sapopsapp where I_POID = poinf.id GROUP BY I_POID) `售前申请编号`,
DATE_FORMAT(poinf.CREATE_TIME,'%Y-%m-%d') `项目商机创建日期`,
note.S_PRJNOS S_PRJNOS,note.ID ID,note.S_APPSTATUS, cast(poinf.ID as char) poID,
pocust.S_CUSTNAME `客户名称`,
poinf.S_POCODE `项目商机编号`,
poinf.S_PONAME `项目商机名称`,
cont.S_CONCODE `合同编号`,
DATE_FORMAT(POINF.DT_PROBSATRT,'%Y-%m-%d') `项目商机开始日期`,
DATE_FORMAT(POINF.DT_PROBEND,'%Y-%m-%d')	 `项目商机结束日期`,
DATE_FORMAT(poinf.DT_CONDATE,'%Y-%m-%d')	 `预计合同签约日期`,
DATE_FORMAT(case when DT_PRODATE is null then DT_PREBEGD else DT_PRODATE END,'%Y-%m-%d') `项目预计开始日期`,
case when I_PROCYCLE is null then 12*(year(DT_PREENDD)-year(DT_PREBEGD))+(month(DT_PREENDD)-month(DT_PREBEGD)) else I_PROCYCLE end `项目预计实施周期`,
translatedict('bussCONstate',poinf.S_CONSTATE) `签约状态`,
translatedict('POSTAGE',poinf.S_POSTAGE) `项目商机阶段`,
translatedict('POTYPE',poinf.S_POTYPE) `项目商机类型`,
translatedict('SIGNRATE',poinf.S_SIGNRATE) `项目商机签约可能性`,
translatedict('PROATTR',poinf.S_PROATTR) `项目属性`,
translatedict('PROOPTYPE',poinf.S_OPERTYPE) `项目商机操作类型`,
translatedict('BIDRST',poinf.S_BIDRST) `项目商机投标结果`,

tec.REAL_NAME `客户经理`,
tecarea.ORG_NAME `客户经理所属区域`,
sale.REAL_NAME `销售代表`,
salearea.ORG_NAME `销售所属区域`,
translatedict('ApproStatus',poinf.S_APPSTATUS) `审批状态`,
poinf.DL_SUMAMT `项目商机预计总价`,
ifnull(note.DL_PROAMT,0) `已立项金额`,
poinf.DL_SUMDAYAMT `预计人天总额`,
poinf.DL_SUMFEE `预计费用总额`,
DL_OCCFEE `费用预算已占用金额`,
DL_ASSFEE `费用预算已分配金额`,
DL_UNASSFEE `费用预算未分配金额`,
poinf.DL_OCCAMT `人天预算已占用金额`,
DL_ASSAMT `人天预算已分配金额`,
DL_UNASSAMT `人天预算未分配金额`,
(TO_DAYS(DT_CONDATE)-TO_DAYS(DATE_FORMAT(NOW(),'%Y%m%d'))) as `签约预警(距当前日期)`,
(TO_DAYS(IFNULL(DT_PRODATE,DT_PREBEGD))- TO_DAYS(NOW())) as `签约预警(距项目开始日期)`

from mdl_aos_sapoinf poinf
left join (
	SELECT SUM(p.DL_BUDCOAMTI) DL_PROAMT, I_POID, p.S_APPSTATUS S_APPSTATUS,GROUP_CONCAT(p.ID ORDER BY p.id) ID, GROUP_CONCAT(p.S_PRJNO ORDER BY p.id) S_PRJNOS
	from mdl_aos_project p
	where 1=1 
	and p.IS_DELETE = 0 and p.S_PRJSTATUS <> '01' and p.S_PRJSTATUS <> '06'
	GROUP BY i_poid 
) note on note.I_POID = poinf.ID
left join (
	SELECT S_CONCODE, I_POID
	FROM mdl_aos_sacont 
	WHERE IS_DELETE = 0 AND S_CONSTATUS != '02'
	GROUP BY I_POID
) cont on cont.I_POID = poinf.ID
left join mdl_aos_sacustinf pocust on pocust.ID = poinf.I_CUSTID
left join plf_aos_auth_user sale on sale.ID = poinf.S_SALEMAN
left join plf_aos_auth_user tec on tec.ID = poinf.OWNER_ID
left join plf_aos_auth_org tecarea on tecarea.ORG_CODE = left(tec.org_code,13)
left join plf_aos_auth_org salearea on salearea.ORG_CODE = LEFT(sale.org_code,13)
where 1=1
and poinf.IS_DELETE = 0
and !(poinf.S_APPSTATUS<>1 and poinf.S_OPERTYPE = '001')