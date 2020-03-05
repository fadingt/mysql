SELECT
S_PRJNO, S_PRJNAME,
-- ngoss.translatedict('OPERTYPE',p.S_OPERTYPE) `操作类型`,
-- ngoss.translatedict('prjstatus',p.S_PRJSTATUS) `项目状态`,
-- pm.REAL_NAME `项目经理`,
-- ngoss.getfullorgname(pm.ORG_CODE) `项目经理所属部门`,
-- tec.REAL_NAME `客户经理`,
-- ngoss.getfullorgname(tec.ORG_CODE) `客户经理所属部门`
''
from mdl_aos_project p
left join mdl_aos_sapnotify note on p.I_PRJNOTICE = note.ID
left join mdl_aos_sapoinf poinf on poinf.ID = note.I_POID
left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
left join plf_aos_auth_user tec on tec.ID = poinf.OWNER_ID
where p.IS_DELETE = 0 and p.S_PRJSTATUS = 07

ORDER BY p.S_OPERTYPE, p.ID