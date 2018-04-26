	SELECT
		budgetid,	budgetnature,	budgettype,	budgetno,-- 预算编号 类型
-- 		left(happendate,6) yearmonth, 
SUM(amt) amt, -- 费用发生年月/金额
		accstatus-- 记账状态
	from report_reimbursement_paymentbill
	where accstatus = '已记账'
	GROUP BY budgetid
-- , left(happendate,6)
ORDER BY budgetno
;

	SELECT SUM(amt),extend1
-- ,year, month
	FROM t_report_cost_voucher_fy
	GROUP BY extend1
ORDER BY extend1
;

SELECT budgetno, billid, payamount, accstatus, amt from report_reimbursement_paymentbill where budgetno like 'QT-2017-0016' and accstatus = '已记账';
SELECT id, billno, acctcreatdate, pzleibie, zhaiyao, amt, extend1 from t_report_cost_voucher_fy where extend1 like 'QT-2017-0016';
