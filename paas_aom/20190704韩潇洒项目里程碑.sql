SELECT
p.*,
ngoss.translatedict('PRJSTAGE', prstage.S_STAGENAME) `里程碑名称`,
DATE_FORMAT(prstage.DT_PSTADATE,'%Y%m%d') `预计开始日期`,
DATE_FORMAT(prstage.DT_PENDDATE,'%Y%m%d') `预计结束日期`,
DATE_FORMAT(prstage.DT_FINDATE,'%Y%m%d') `技术确认完成日期`,
(CASE WHEN prstage.DT_FINDATE is NULL THEN TO_DAYS(prstage.DT_PENDDATE)-TO_DAYS(NOW()) ELSE NULL END)  `预警`

FROM mdl_aos_prstage prstage 
join (
	SELECT 
	p.id, S_PRJNO `项目编号`,S_PRJNAME `项目名称`,
	pm.REAL_NAME `项目经理`, ngoss.getfullorgname(pm.ORG_CODE) `项目经理所属部门`,
	ngoss.getusername(p.S_DIRECTOR) `项目总监`,
	ngoss.translatedict('PRJSTATUS',p.S_PRJSTATUS) `项目状态`,
	ngoss.translatedict('PRJCLASS',p.S_PRJCLASS) `业务类型`,
	ngoss.getfullorgname(p.S_DEPT) `项目所属部门`,
	tec.REAL_NAME `客户经理`, ngoss.getfullorgname(tec.ORG_CODE) `客户经理所属部门`,
	(own.deptMana) `条线负责人` 
	FROM mdl_aos_project p
	LEFT JOIN (SELECT ngoss.getusername(S_PARTOWNER) deptMana,S_ORGCODE orgCode from mdl_aos_hrorg) own ON own.orgCode = p.S_DEPT 
	left join mdl_aos_sapnotify AS sapnotify on sapnotify.id = p.I_PRJNOTICE 
	LEFT JOIN mdl_aos_sapoinf AS sapoinf ON sapnotify.I_POID = sapoinf.ID AND sapnotify.IS_DELETE=0
	left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
	left join plf_aos_auth_user tec on tec.id = sapoinf.OWNER_ID
	where 1=1
-- and p.S_PRJTYPE = 'YY'
and p.IS_DELETE=0
)p on prstage.i_prjid = p.id
where 1=1
AND prstage.IS_DELETE=0 
AND prstage.S_ISMARKER=2