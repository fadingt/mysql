SELECT
S_BUSNUM, S_SRCNUM, DL_TAXAMOUNT `税额`, DL_TAXSUM `含税金额`, dl_nottaxsum `未税金额`, DL_REALSUM
FROM `mdl_aos_fitradeif`
where S_SOURCEKD = 10002
and DL_TAXAMOUNT != 0
and S_SRCNUM in(

SELECT S_SRCNUM
from mdl_aos_fitradeif
where S_SOURCEKD = 10002
GROUP BY S_SRCNUM HAVING COUNT(*) >1
)
ORDER BY S_SRCNUM