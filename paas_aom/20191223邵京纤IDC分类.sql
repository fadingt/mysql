SELECT
S_PRJNO `项目编号`, S_PRJNAME `项目名称`, 
translatedict('IDC1', S_IDC1) `解决方案`,
translatedict('IDC2', S_IDC2) `解决子案2`,
getfullorgname(S_DEPT) `项目所属部门`
from mdl_aos_project
where IS_DELETE = 0 and S_APPSTATUS <> '01' and S_APPSTATUS <> '06'
and S_PRJTYPE = 'yy'