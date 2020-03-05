SELECT
billno, b.unitname, b.brno, b.calcdept,
getunitname(financialbody), a.payamount, 
-- d.levela, d.levelb,  
c.level2text,
getusername(a.createuser), acctdate, extend1, extend2, course, c.level2value
from t_budget_paymentbill_manual a
join t_sys_mngunitinfo b on a.depid = b.unitid
join t_budget_accountingsubject c on a.course = c.subjectid
-- join report_reimbursement_paymentbill d on a.id = d.billid
WHERE left(acctdate,4) =2018 
and extend1 = ''