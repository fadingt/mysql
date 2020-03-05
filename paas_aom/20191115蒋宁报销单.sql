SELECT
-- *
S_BGCODE, S_BGTYPE, S_BGCLASS, S_TYPE, S_APPLICANT
from mdl_aos_dareim
where S_REIMCODE in ('BX-20191105-28980', 'BX-20191115-30248');

SELECT *
from mdl_aos_fibgtapp
where S_BUDGTCODE like 'GDZC-2019-0465'；

SELECT
-- DISTINCT s_bgclass, SUBSTRING_INDEX(s_bgcode,'-',1)
*
from mdl_aos_dareim
where SUBSTRING_INDEX(s_bgcode,'-',1) = 'GDZC'