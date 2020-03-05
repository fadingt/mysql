SELECT * from (
SELECT contractid, contractprice, effectstatus, type from t_contract_main
) main
left join (
SELECT protocolorcontractid, poprice from t_contract_order
) a on main.contractid = a.protocolorcontractid

where effectstatus not in (5,8) and main.type = 1

-- SELECT * from t_contract_projectrelation 

-- SELECT * from t_contract_main where contractid = 153437