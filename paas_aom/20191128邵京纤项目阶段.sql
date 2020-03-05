SELECT
p.*,
ngoss.translatedict('PRJSTAGE', prstage.S_STAGENAME) `里程碑名称`,
DATE_FORMAT(prstage.DT_PSTADATE,'%Y%m%d') `预计开始日期`,
DATE_FORMAT(prstage.DT_PENDDATE,'%Y%m%d') `预计结束日期`,
DATE_FORMAT(prstage.DT_FINDATE,'%Y%m%d') `技术确认完成日期`
FROM mdl_aos_prstage prstage 
join (
	SELECT 
	p.id, S_PRJNO `项目编号`,S_PRJNAME `项目名称`,
	pm.REAL_NAME `项目经理`,
	tec.REAL_NAME `客户经理` 
	FROM mdl_aos_project p
	join ngoss.`邵京纤项目` t on p.S_PRJNO = t.`项目编号`
	LEFT JOIN mdl_aos_sapoinf poinf ON poinf.ID = p.I_POID
	left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
	left join plf_aos_auth_user tec on tec.id = poinf.OWNER_ID
	where p.S_PRJTYPE = 'YY' and p.IS_DELETE=0
)p on prstage.i_prjid = p.id
where 1=1
AND prstage.IS_DELETE=0 
-- AND prstage.S_ISMARKER='2'