SELECT
a.S_CASECODE `事项编号`, a.S_CASENAME `事项名称`, translatedict('ApproStatus', a.S_APPSTATUS) `事项审批状态`,
DATE_FORMAT(MIN(b.DT_STARTTIME),'%Y-%m-%d') `项目最早开始日期`,
DATE_FORMAT(MAX(b.DT_ENDTIME),'%Y-%m-%d') `项目最晚结束日期`
from mdl_aos_sacase a
left join mdl_aos_project b on a.I_POID = b.I_POID
where a.IS_DELETE = 0
GROUP BY a.ID