SELECT
	-- t3.contractid,

	t3.contractno,
	t3.oldcontractno,
	t3.contractname,
	t3.company,
	t3.custname,
	t3.begintime,
	t3.endtime,
	translatedict('IDFS000273', t3.type),
	t3.contractprice,
	-- translatedict('IDFS000132', t3.moneytype),
	-- t3.currency,
	-- t3.localcurrency,
	translatedict('IDFS000145', t3.billtype),
	t3.billtax,
	translatedict('IDFS000087', t3.issuemethod),
	t3.changeexplain,
	t3.remark,
	translatedict('IDFS000136', t3.effectstatus),
	t3.register,
	translatedict('IDFS000068', t3.operatetype),
	-- t3.kind,
	-- t3.serviceprice,
	t3.billtax as servicetaxrate, -- 合同主表的合同服务税率为空，因此替换为billtax
	-- t3.productprice,
	t3.producttaxrate,
	t3.sale,
	left(t3.COMPLETEDDATE, 4) year,
	left(t3.COMPLETEDDATE, 10) COMPLETEDDATE 
FROM view_report_addcontract  t3

order by  begintime