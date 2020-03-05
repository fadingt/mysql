SELECT
	S_BGCODE, SUM(case when S_APPSTATUS in (1,3) then DL_SUMREIM else 0 END)
from mdl_aos_dareim
where IS_DELETE = 0 
GROUP BY S_BGCODE;

SELECT *
from mdl_aos_daloan