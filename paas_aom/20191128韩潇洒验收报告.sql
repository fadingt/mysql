SELECT
b.S_CKNO `验收报告编号`,
(case b.S_OPTYPE when 1 then '提交验收报告' when 2 then '验收报告调整' END) `验收报告操作类型`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'ApproStatus' and DICT_CODE = b.S_APPSTATUS) `验收报告审批状态`,
 b.S_REMARK `验收说明`,
c.*,
(SELECT dict_name from plf_aos_dictionary where DICT_CODE = a.S_STGNAME and DICT_TYPE = 'checkstg')  `阶段名称`,
DATE_FORMAT(DT_CHECKTIME,'%Y-%m-%d') `预计验收日期`,
DL_CHECKAMT `预计验收金额`, CONCAT(TRUNCATE(DL_CHECKRATE*100,1),'%') `验收占比`,
DATE_FORMAT(DT_CHECKDATE,'%Y-%m-%d') `实际验收日期`,
case S_IFMAIN when 1 then '否' when 2 then '是' end `是否维保`
from mdl_aos_sacheckstg a
left join mdl_aos_sacheckapp b on a.I_CKID = b.ID and b.IS_DELETE = 0
left join (
SELECT
cont.ID, S_CONCODE `合同编号`, S_CONNAME `合同名称`,
cust.S_CUSTNAME `甲方`, comp.S_COMPNAME `乙方`,
case S_CONTYPE when '01' then '固定金额' when '02' then '框架协议' end `预计签约类型`,
case S_CONTYPE when '01' then cate.dict_name when '02' then PROTCATE.dict_name end  `签约子类型`,
sale.REAL_NAME `销售负责人`, tec.REAL_NAME `客户经理`,
cont.DL_CONAMT `合同金额`, poinf.S_POCODE `项目商机编号`, p.prjnos `项目编号`
from mdl_aos_sacont cont
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'contactCategory') cate on cate.dict_code = cont.S_CONCATE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'PROTCATE') PROTCATE on PROTCATE.dict_code = cont.S_PROTCATE
left join plf_aos_auth_user sale on sale.id = cont.OWNER_ID
left join mdl_aos_sapoinf poinf on poinf.ID = cont.I_POID
left join (SELECT GROUP_CONCAT(S_PRJNO) prjnos, I_POID from mdl_aos_project where IS_DELETE = 0 and S_PRJTYPE = 'YY' AND S_PRJSTATUS<>'06'  AND S_PRJSTATUS<>'01'
GROUP BY I_POID
) p on p.I_POID = cont.I_POID
left join plf_aos_auth_user tec on tec.id = poinf.OWNER_ID
left join mdl_aos_sacustinf cust on cust.ID = cont.S_PARTYA
left join mdl_aos_compcode comp on comp.ID = cont.S_PARTYB
where cont.IS_DELETE = 0
)c on b.I_CONID = c.ID
where a.IS_DELETE = 0 and a.S_TYPE = 3
-- and c.`合同编号` = 'HT-YY-2018-0660-02-5374'
-- and b.S_CKNO = 'YSBG-00000003'


