begin
DELETE from t_project_stage_ys_tian;
insert into t_project_stage_ys_tian
SELECT
	t1.*, CASE
WHEN t1.ybilldate IS NOT NULL and t1.ybilldate != '' THEN
	t1.billamt
ELSE
	NULL
END AS ybillamt,
 CASE
WHEN t1.yrecedate IS NOT NULL and t1.yrecedate != '' THEN
	t1.receamt
ELSE
	NULL
END AS yreceamt,
 CASE
WHEN t1.sbilldate IS NOT NULL and  t1.sbilldate != '' THEN
	t1.billamt
ELSE
	NULL
END AS sbillamt,
 CASE
WHEN t1.srecedate IS NOT NULL and t1.srecedate != '' THEN
	t1.receamt
ELSE
	NULL
END AS sreceamt
FROM
	(
		SELECT
			t.*, sum(ifnull(c.amt, 0)) billamt,
			sum(ifnull(c.paymented, 0)) receamt,
			max(d.ybilldate) ybilldate,
			max(d.yrecedate) yrecedate,
			max(d.sbilldate) sbilldate,
			max(d.srecedate) srecedate
		FROM
			(
				SELECT
					a.projectid,
					a.projectno,
					a.projectname,
					getusername (a.pm) pm,
					getusername (a.pd) pd,
					getusername (a.saleid) saleid,
					getunitname (a.deptid) deptid,
					b.templateid,
					translatedict ('IDFS000077', b.projectstep) projectstep,
					b.predictstartdate,
					b.predictenddate,
					b.extend1 jswcrq
				FROM
					t_project_projectinfo a,
					t_project_stepbudget b
				WHERE
					a.projecttype NOT IN (5, 8)
				AND a.projectid = b.projectid
			) t
		LEFT JOIN t_contract_project_stage c ON t.projectid = c.projectid
		AND t.templateid = c.projectstageid
		LEFT JOIN t_contract_stage_ys_tian d ON c.extend1 = d.type
		AND c.stageid = d.id
		inner join t_contract_main e on d.contractid = e.contractid and e.effectstatus not in (7,8)
		GROUP BY
			t.projectid,
			t.templateid
	) t1;
end