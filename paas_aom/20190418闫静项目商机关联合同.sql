SELECT
year(coinf.DT_YEARR) `客户商机年份`,
poinf.S_POCODE `项目商机编号`, poinf.S_PONAME `项目商机名称`,
cont.S_CONCODE `合同编号`, cont.S_CONNAME `合同名称`,
cont.DL_CONAMT `合同金额`,
IFNULL(ngoss.translatedict('PROTCATE',S_PROTCATE),ngoss.translatedict('contactCategory',S_CONCATE)) `合同类型`,
	DATE_FORMAT(cont.DT_BEGDATE,'%Y-%m-%d') `合同开始日期`,
	DATE_FORMAT(cont.DT_ENDDATE,'%Y-%m-%d') `合同结束日期`,
	DATE_FORMAT(cont.DT_PSIGNDATE,'%Y-%m-%d') `预计签约日期`,
	DATE_FORMAT(cont.DT_ASIGNDATE,'%Y-%m-%d') `实际签约日期`,
	DATE_FORMAT(cont.DT_FILEDATE,'%Y-%m-%d') `归档日期`,
ngoss.translatedict('contactType',s_CONSTATUS) `合同状态`,
ngoss.translatedict('PactFile',S_FILSTATUS) `归档状态`,
ngoss.translatedict('ASSSTA',cont.S_ASSSTA) `分配状态`
from mdl_aos_sacont cont
left join mdl_aos_sapoinf poinf on poinf.ID = cont.I_POID
left join mdl_aos_sacoinf coinf on coinf.ID = poinf.I_COID
where 1=1
and cont.IS_DELETE = 0 and cont.S_APPSTATUS = 1
and poinf.IS_DELETE = 0 
-- and poinf.S_APPSTATUS != 1