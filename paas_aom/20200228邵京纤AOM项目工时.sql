SELECT b.S_PRJNO `项目编号`, b.S_PRJNAME `项目名称`, IFNULL(sum(a.I_RLABHOUR/8),0) `实际报工/人天`, sum(a.DL_RLABTLFEE) `实际成本`
from mdl_aos_prmonthpl a
join mdl_aos_project b on a.I_PRJID = b.ID
where a.IS_DELETE = 0 and b.IS_DELETE = 0 and b.S_PRJTYPE = 'yy'
GROUP BY a.I_PRJID