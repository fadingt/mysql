SELECT 
a.I_PRJID, a.S_PYEARMON, a.ID,
S_ALTERSEQ `变更流水号`,  DL_PLABTLFEE `计划人力成本`, DL_PROOMFEE `计划费用成本`
FROM mdl_aos_prmonthpl_his a
JOIN (
	SELECT MIN(id+0) as min_id, S_PYEARMON, I_PRJID
	from mdl_aos_prmonthpl_his 
	where IS_DELETE = 0 
	GROUP BY I_PRJID, S_PYEARMON
) b on a.ID = b.min_id
-- where a.I_PRJID = 150076
ORDER BY a.I_PRJID