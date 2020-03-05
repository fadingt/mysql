SELECT
S_PRJNO `项目编号`,
S_PRJNAME `项目名称`,
DL_BUDCOAMTI `实际立项金额`,
ngoss.translatedict('PRJSTATUS',S_PRJSTATUS) `项目状态`,
ngoss.translatedict('opertype', S_OPERTYPE) `项目操作类型`,
ngoss.translatedict('ApproStatus',S_APPSTATUS) `审批状态`,
ngoss.getusername(S_MANAGER) `项目经理`,
ngoss.getusername(S_DIRECTOR) `项目总监`,
ngoss.getfullorgname(S_DEPT) `项目所属部门`,
DATE_FORMAT(DT_STARTTIME,'%Y%m%d') `项目开始日期`,
DATE_FORMAT(DT_ENDTIME,'%Y%m%d') `项目结束日期`,
ngoss.translatedict('prjclass',S_PRJCLASS) `项目分类`,
ngoss.translatedict('PRJTYPE', S_PRJTYPE) `项目类型`
from mdl_aos_project a
where S_PRJTYPE = 'YF'