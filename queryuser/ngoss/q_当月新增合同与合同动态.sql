SELECT
	a.lastmodtime1, b.COMPLETEDDATE, b.contractid
from 
(
	SELECT 
		contractid contractid1, lastmodtime lastmodtime1 
	from t_contract_maintmp a 
	join (SELECT MIN(id) id1 from t_contract_maintmp GROUP BY contractid) b on a.id = b.id1
	WHERE status = 3
--  and type in (2,4) 
and left(lastmodtime,4) >= 2018
) a 
RIGHT join (
	SELECT *
	from view_report_addcontract  
	where left(COMPLETEDDATE,4) >= 2018
) b on a.contractid1 = b.contractid