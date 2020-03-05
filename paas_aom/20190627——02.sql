SELECT 
-- *
I_PRJID, DL_INSUMAMT `采购总成本`, DL_STOCKAMT `实际已采购成本`
from mdl_aos_prpurchas
where IS_DELETE = 0
and I_PRJID = 150076
ORDER BY I_PRJID;

SELECT DL_BUDPURAMT `预算采购成本`, DL_BUDLABAMT `预算人力成本`, DL_BUDCOSAMT `预算费用成本`, 
DL_CRYBUDFEE `结转预算费用`, DL_INITCRYOR `16年期初成本`, DL_BUDGRRATE `毛利率`, DL_CRYORPUR `结转采购成本`,
DL_BUDTOLCOS `预算总成本`, DL_RTOTALFEE `实际费用`, DL_BUDGROSS `预算毛利`,DL_BUDCOAMTI/1.06
from mdl_aos_project where ID = 150076
;
-- 人力								费用
-- 3583463.00000	15000.00000
-- 3364211.83000	75000.00000

SELECT
ID,I_PRJID, DL_INSUMAMT `采购总成本`, DL_STOCKAMT `实际已采购成本`
from mdl_aos_prpurchas_his a
join (SELECT MIN(id+0) as min_id from mdl_aos_prpurchas_his where IS_DELETE=0 GROUP BY I_PRJID) b on a.ID = b.id
where 1=1
and I_PRJID = 150076
ORDER BY I_PRJID;