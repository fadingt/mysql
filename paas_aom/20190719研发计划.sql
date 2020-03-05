-- /aom/RandDplanDetail?sourceViewId=1260&recordId=203
[{"url":"/aom/applicationProjectDetail?sourceViewId=916&recordId=","IDValKey":"ID","aValKey":"S_PRJNOS"}]
-- 研发计划：

/*

研发计划编号、研发计划名称、计划总金额、计划状态、操作类型、审批状态、所属部门、计划开始时间、计划结束时间、计划费用成本
*/

SELECT
id, S_PLANCODE, S_PLANNAME `研发计划名称`,
DL_ALLMONEY `计划总金额`,
ngoss.translatedict('FPSTATUS',S_PLSTATUS) `计划状态`,
ngoss.translatedict('FPoperation',S_OPERTYPE) `操作类型`,
ngoss.translatedict('ApproStatus',S_APPSTATUS) `审批状态`,
ngoss.getfullorgname(S_DEPT) `所属部门`,
DATE_FORMAT(DT_STARTDATE,'%Y-%m-%d') `计划开始日期`,
DATE_FORMAT(DT_ENDDATE,'%Y-%m-%d') `计划结束日期`,
DL_COSTMONEY `计划费用成本`
from mdl_aos_prplan
where IS_DELETE = 0 
-- and !(S_OPERTYPE=1 and S_APPSTATUS<>1)