

SELECT 
SUM(DL_REPYMONEY), GROUP_CONCAT(DT_REPAYDATE), S_REIMID
from mdl_aos_darepayhs
where S_REIMID is not null and IS_DELETE = 0
GROUP BY S_REIMID

SELECT DL_SUMREIM
from mdl_aos_dareim
where id = 10076