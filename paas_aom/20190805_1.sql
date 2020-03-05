SELECT
x.type,
x.isactingstd,
x.budgettype,
ngoss.translatedict('costtypes', type)
from (
SELECT DISTINCT type, SUBSTRING_INDEX(budgetno,'-',1) budgettype, isactingstd
from t_snap_fi_standardcost
-- where type = 5
)x
ORDER BY x.type