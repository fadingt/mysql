SELECT 
poinf.S_POCODE `项目商机编号`, tec.REAL_NAME `客户经理`, tecarea.S_NAME `客户经理部门`,
S_CONCODE `合同编号`, S_CONNAME `合同名称`,
 CONSTATUS.dict_name `合同状态`, 
assigner.REAL_NAME `分配人`,
(SELECT dict_name from plf_aos_dictionary where DICT_TYPE = 'ASSSTA' and DICT_CODE = cont.S_ASSSTA) `合同是否分配`,
stage.S_STAGEDES `合同阶段名称`,
-- DATE_FORMAT(,'%Y-%m-%d')
DATE_FORMAT(stage.DT_PREBILLD,'%Y-%m-%d') `预计开票时间`,
stage.DL_BILLAMT `预计开票金额`,
DATE_FORMAT(stage.DT_PREBACKD,'%Y-%m-%d') `预计回款时间`,
stage.DL_BACKAMT `预计回款金额`,
DATE_FORMAT(stage.DT_ACBILLD,'%Y-%m-%d') `实际开票时间`,
stage.DL_ACBILLAMT `实际开票金额`,
DATE_FORMAT(stage.DT_ACAMTD,'%Y-%m-%d') `实际回款时间`,
stage.DL_ACBACKAMT `实际回款金额`,
(SELECT dict_name from plf_aos_dictionary where DICT_TYPE = 'ASSSTA' and DICT_CODE = stage.S_ASSSTA) `阶段是否分配`
from mdl_aos_sacont cont
join mdl_aos_sapoinf poinf on poinf.ID = cont.I_POID
left join mdl_aos_saconstag stage on stage.I_CONID = cont.id and stage.IS_DELETE = 0
left join plf_aos_auth_user assigner on assigner.ID = cont.S_ASSIGNER
left join plf_aos_auth_user tec on poinf.OWNER_ID = tec.ID
left join mdl_aos_hrorg tecarea on left(tec.ORG_CODE,13) = tecarea.s_orgcode
-- left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.dict_code = cont.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'contactType') CONSTATUS on CONSTATUS.dict_code = cont.s_CONSTATUS
where 1=1
-- and S_CONCODE like 'HT-YY-2019-0163-0044-0915'
-- and cont.S_ASSSTA is null
and S_CONTYPE = 01
and cont.IS_DELETE = 0;