SELECT
case a.isactingstd when 0 then '非财务' when 1 then '财务' end flag, a.budgettype, b.DICT_NAME
FROM(
		SELECT 
		DISTINCT isactingstd, type, budgettype
		from t_snap_fi_standardcost
	WHERE budgettype is not null
)a
left join plf_aos_dictionary b on a.type = b.DICT_CODE and b.DICT_TYPE = 'costtypes'
ORDER BY a.budgettype, a.isactingstd