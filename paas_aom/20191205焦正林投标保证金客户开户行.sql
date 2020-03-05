SELECT
-- S_PAYCODE, I_BIDID,
translatedict('trfl',b.S_ISBIDAMT) `是否有投标保证金`,
b.S_BIDCODE, cust.S_CUSTNAME,  b.s_custname `招标人`,
translatedict('pType', b.S_PAYTYPE) `打款方式`, 
b.S_ACCNAME `账户名`, b.S_ACCBANK `开户行`, b.S_ACCOUNT `银行账号`

from mdl_aos_bidpayapp a
left join mdl_aos_sabidapp b on a.I_BIDID = b.ID
left join mdl_aos_sacustinf cust on b.I_CUSTID = cust.ID
left join mdl_aos_fiaccoper fiacc on fiacc.ID = a.I_PAYACC
where 1=1
-- and S_ISBIDAMT != 2
-- and S_PAYCODE = 'BZJFK-20191203-00149'
and a.IS_DELETE = 0 and a.S_APPSTATUS = 1
and b.IS_DELETE = 0 and b.S_APPSTATUS = 1