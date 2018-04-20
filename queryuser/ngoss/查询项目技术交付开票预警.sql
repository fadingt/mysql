SELECT
		a.projectno,
		a.projectname,
		a.projectstep,
		a.pm,
		a.pd,
		a.predictenddate projpredictenddate,
		a.jswcrq projjswcrq,
		a.ybilldate,a.ybillamt,a.sbilldate,a.sbillamt,a.yrecedate,a.yreceamt,a.srecedate,a.sreceamt,
		case when a.sbillamt is not null then '已开票' else '未开票' end kpyj,
		
		c.contractid, c.contractno, c.contractname ,c.id, c.orderid, c.pono, c.stagename
		
FROM t_project_stage_ys_tian a
-- LEFT JOIN t_project_stepbudget b on a.projectid = b.projectid and a.templateid = b.templateid
LEFT JOIN
(
	SELECT
		t1.projectid, t1.projectstageid,
		t2.*
	FROM
		t_contract_project_stage t1,
		t_contract_stage_ys_tian t2
	WHERE
		t1.extend1 = t2.type AND t1.stageid = t2.id 
ORDER BY projectid
-- 	GROUP BY t1.projectid, t1.projectstageid
) c on c.projectid = a.projectid and c.projectstageid = a.templateid

join (select contractid, effectstatus from t_contract_main where effectstatus != 5 and effectstatus  != 8 ) m on c.contractid = m.contractid

where 1= 1
and a.ybilldate >= 20160101 and a.yrecedate >= 20160101
-- {projectno}
-- {projectname}
-- {contractno}
-- {contractname}
-- {beiyong}
-- {pm}
-- {pd}
ORDER BY a.projectid, a.projectstep