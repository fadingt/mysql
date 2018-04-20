SELECT 
	old.contractno,
	new.contractno
from t_contract_main new
left join 
(
	SELECT
-- GROUP_CONCAT(a.contractno) 
a.contractno, 
b.contractno,
-- b.contractid 
''
	from t_contract_maintmp a
	join t_contract_main b
	WHERE b.contractid = a.contractid and a.contractno != b.contractno 
	GROUP BY b.contractid
) old on old.contractid = new.contractid
WHERE old.contractno is not null
