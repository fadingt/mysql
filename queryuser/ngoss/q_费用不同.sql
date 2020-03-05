SELECT
*
from t_report_cost_voucher_fy
where id in (29381,38632);
-- WHERE extend1 like 'BMYS-2017-0059';
-- WHERE year like 2017
-- 
SELECT
*
from t_budget_paymentbill
WHERE billno like 'ZCPD-00041570' or billno like 'ZCPD-00029895';
-- 
SELECT *
from report_reimbursement_paymentbill
-- WHERE budgetno like 'BMYS-2017-0059';
where billid in (29381,38632);

-- ZCPD-00029895
-- ZCPD-00041570