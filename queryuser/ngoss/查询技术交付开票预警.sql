SELECT
b.projectid,
	t.contractno,
	t.contractname,
	t.pono,
	t.typename,
	t.stagename,

	t.ybilldate,
	t.ybillamt,
	t.sbilldate,
	t.sbillamt,

	t.yrecedate,
	t.yreceamt,
	t.srecedate,
	t.sreceamt,

	b.jsyjwcdate,
	b.jsqrwcdate,
	b.projectno,
	b.projectname,
	b.projectstep,
	b.pm,
	b.pd,
	b.saleid beiyong,
	b.projpredictenddate,
	b.projjswcrq,
	CASE
WHEN t.sbillamt IS NOT NULL THEN
	'已开票'
WHEN b.jsqrwcdate IS NULL THEN
	'未确认完成日期'
ELSE
	TO_DAYS(b.jsqrwcdate) - TO_DAYS(DATE_FORMAT(now(), '%Y%m%d'))
END AS kpyj,
	CASE
WHEN t.sreceamt <> '' AND t.sreceamt = t.yreceamt THEN
	'已回完'
WHEN t.sreceamt is null THEN
	TO_DAYS(t.yrecedate)-TO_DAYS(NOW())
ELSE
	'还没想好233'
END AS hkyj
FROM
	t_contract_stage_ys_tian t
LEFT JOIN (
	SELECT
b.projectid,
		b.extend1,
		b.stageid,
		max(c.predictenddate) jsyjwcdate,
		max(c.extend1) jsqrwcdate,
		d.projectno,
		d.projectname,
		d.pm,
		d.pd,
		d.predictenddate projpredictenddate,
		d.jswcrq projjswcrq,
		d.projectstep,
		d.saleid
	FROM
		t_contract_project_stage b,
		t_project_stepbudget c,
		t_project_stage_ys_tian d

	WHERE
		b.projectid = c.projectid AND b.projectid = d.projectid
	AND b.projectstageid = c.templateid AND b.projectstageid = d.templateid
	GROUP BY
		b.extend1,
		b.stageid
) b ON t.type = b.extend1
AND t.id = b.stageid
join (select contractid, effectstatus from t_contract_main where effectstatus != 5 and effectstatus  != 8 ) m on t.contractid = m.contractid


where 1= 1
and ybilldate>=20160101 and yrecedate>=20160101
-- and projectno is null
