SELECT
-- a.contractid, a.contractno, a.contractprice,
-- left(b.lastmodtime,8),
-- a.contracttime
SUM(a.contractprice)
FROM(
		SELECT
		contractid, createtime, lastmodtime, effectstatus, contractprice, contracttime, contractno, isfile
		from `t_contract_main`
		WHERE type in (2,4) 
-- and isfile = 1
-- and effectstatus not in (7,8)
) c1
join(
	SELECT 
		id id1, contractid contractid1, lastmodtime lastmodtime1 
	from t_contract_maintmp a 
	join (SELECT MIN(id) id1 from t_contract_maintmp GROUP BY contractid) b on a.id = b.id1
	WHERE status = 3 and type in (2,4)
)ctemp on ctemp.contractid1 = c1.contractid
WHERE 1=1
-- and (left(b.lastmodtime,4) =2018 or left(a.contracttime,4) =2018)
-- and left(a.contracttime,4) != left(b.lastmodtime,4)
and left(a.contracttime,4) = 2018
-- and left(b.lastmodtime,4) =2018
-- and a.isfile = 0
-- 67199554.76
-- 72239920.97
-- 153003293.00