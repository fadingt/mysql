SELECT
t.*, t1.`累计实付金额`, t1.`累计实票金额`
from (
	SELECT 
	a.S_ORDERNO `订单编号`, S_ORDERNAME `订单名称`,
	 case when c.S_PROCTYPE is null then '投标申请生成' when c.S_PROCTYPE = 1 then '部门采购'
	when c.S_PROCTYPE = 0 then '项目采购' END `采购类别`,
	comp.S_COMPNAME `付款公司`,
	b.S_SUPNAME `供应商`,
	bgt.S_BUDGTCODE `预算编号`, bgt.S_BUDGTNAME `预算名称`, null `立项金额`,
	null `销售累计实回金额`, a.DL_COUNTAMT `订单金额`,
	paystg.S_STAGENAME `付款阶段名称`,paystg.ID as paystgid,
	(case when payreq.DT_PAYDATE is null then 0 else payreq.DL_ISPAYAMT END) `阶段实付金额`,
	DATE_FORMAT(payreq.DT_PAYDATE,'%Y-%m-%d') `阶段实付日期`,
	bill.DL_COUNTAMT `阶段实开金额`,
	DATE_FORMAT(billdet.INVOICEDATE,'%Y%m%d') `阶段实开日期`
	from mdl_aos_puorder a
	left join mdl_aos_pusuplie b on a.S_SUPNUM = b.ID
	left join mdl_aos_purreq c on a.S_PUREQNO = c.ID
	left join mdl_aos_pupaystg paystg on paystg.S_ORDERID = a.ID
	 left join mdl_aos_pupayreq payreq on paystg.ID = payreq.S_PAYSTAGE and payreq.IS_DELETE = 0
	 left join mdl_aos_pubill bill on paystg.ID = bill.I_PAY_STAGE and bill.IS_DELETE = 0
	 left join (select max(DT_INVOIDATE) INVOICEDATE,S_REGINVONO from mdl_aos_pubilldet where IS_DELETE = 0 GROUP BY S_REGINVONO) billdet 
	 on bill.ID = billdet.S_REGINVONO 
	left join mdl_aos_compcode comp on comp.id = a.S_FINANCODE
	left join mdl_aos_fibgtapp bgt on bgt.ID = a.I_BUDGTCODE
	where a.IS_DELETE = 0 and c.IS_DELETE = 0 and bgt.IS_DELETE = 0
	and c.S_PROCTYPE = 1
	and a.S_APPSTATUS = 1
-- 	and a.S_ORDERNO = 'CGDD-2019-00002'

	union all

	SELECT 
	a.S_ORDERNO `订单编号`, S_ORDERNAME `订单名称`,
	 case when c.S_PROCTYPE is null then '投标申请生成' when c.S_PROCTYPE = 1 then '部门采购'
	when c.S_PROCTYPE = 0 then '项目采购' END `采购类别`,
	comp.S_COMPNAME `付款公司`,
	b.S_SUPNAME `供应商`,
	bgt.S_PRJNO `预算编号`, bgt.S_PRJNAME `预算名称`, bgt.DL_BUDCOAMTI `立项金额`,
	ass.sreceamt `销售累计实回金额`, a.DL_COUNTAMT `订单金额`,
	paystg.S_STAGENAME `付款阶段名称`,paystg.ID,
	(case when payreq.DT_PAYDATE is null then 0 else payreq.DL_ISPAYAMT END) `阶段实付金额`,
	DATE_FORMAT(payreq.DT_PAYDATE,'%Y-%m-%d') `阶段实付日期`,
	bill.DL_COUNTAMT `阶段实开金额`,
	DATE_FORMAT(billdet.INVOICEDATE,'%Y%m%d') `阶段实开日期`
	from mdl_aos_puorder a
	left join mdl_aos_pusuplie b on a.S_SUPNUM = b.ID
	left join mdl_aos_purreq c on a.S_PUREQNO = c.ID
	left join mdl_aos_pupaystg paystg on paystg.S_ORDERID = a.ID
	 left join mdl_aos_pupayreq payreq on paystg.ID = payreq.S_PAYSTAGE and payreq.IS_DELETE = 0
	 left join mdl_aos_pubill bill on paystg.ID = bill.I_PAY_STAGE and bill.IS_DELETE = 0
	 left join (select max(DT_INVOIDATE) INVOICEDATE,S_REGINVONO from mdl_aos_pubilldet where IS_DELETE = 0 GROUP BY S_REGINVONO) billdet 
	 on bill.ID = billdet.S_REGINVONO 
	left join mdl_aos_compcode comp on comp.id = a.S_FINANCODE
	left join mdl_aos_project bgt on bgt.ID = a.I_PRONO
	left join (
	SELECT
		SUM(DL_PRABACKAT) sreceamt, S_PJNO
		from mdl_aos_evidence
		where S_VERSION = (SELECT MAX(S_VERSION) lastVersion FROM mdl_aos_evidence)
		GROUP BY S_PJNO
	)ass on ass.S_PJNO = bgt.S_PRJNO
	where a.IS_DELETE = 0 and c.IS_DELETE = 0 and bgt.IS_DELETE = 0
	and c.S_PROCTYPE = 0 and paystg.IS_DELETE = 0
	and a.S_APPSTATUS = 1
)t
left join (
	SELECT
	SUM(case when payreq.DT_PAYDATE is null then 0 else payreq.DL_ISPAYAMT END) `累计实付金额`,
	SUM(bill.DL_COUNTAMT) `累计实票金额`, a.S_ORDERNO
	from mdl_aos_puorder a
	left join mdl_aos_pupaystg paystg on paystg.S_ORDERID = a.ID
	left join mdl_aos_pupayreq payreq on paystg.ID = payreq.S_PAYSTAGE and payreq.IS_DELETE = 0
	left join mdl_aos_pubill bill on paystg.ID = bill.I_PAY_STAGE and bill.IS_DELETE = 0
	GROUP BY a.S_ORDERNO
)t1 on t.`订单编号` = t1.S_ORDERNO
where 1=1
{订单编号}
ORDER BY t.`订单编号`, t.paystgid