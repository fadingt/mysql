SELECT *
FROM(
		SELECT 
		a.I_PRJID, SUM(DL_PLABTLFEE) `计划人力成本`, SUM(DL_PROOMFEE) `计划费用成本`
		FROM mdl_aos_prmonthpl_his a
		JOIN (
			SELECT MIN(id+0) as min_id, S_PYEARMON, I_PRJID
			from mdl_aos_prmonthpl_his 
			where IS_DELETE = 0 
			GROUP BY I_PRJID, S_PYEARMON
		) b on a.ID = b.min_id
		GROUP BY a.I_PRJID
)t
left join (
		SELECT 
		I_PRJID, SUM(DL_PLABTLFEE) `计划人力成本`, SUM(DL_PROOMFEE) `计划费用成本`
		FROM mdl_aos_prmonthpl
		where IS_DELETE = 0
		GROUP BY I_PRJID
)t1 on t.I_PRJID = t1.I_PRJID
where t.`计划人力成本` != t1.`计划人力成本` or t.`计划费用成本` != t1.`计划费用成本`