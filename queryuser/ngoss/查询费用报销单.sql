SELECT t.userid, t.id, t.reimbursementno, t.budgetid, t.budgetnature, t.budgettype, 
				 t.figuredest, t.depid, t.feetype, t.spendtype, t.reimbursementcycle, t.createtime, 
				 t.invoicecount, t.amount, t.reimbursementstatus, t.approver, t.approvalstatus, t.applydate, 
				 t.remark, t.extend1, t.extend2, t.extend3, t.extend4, t.budgetname, t.unitname, t.tablename,
				  t.figuredestname, t.financialbody, t.financialbodyname, t.costid, t.approvestep, 
				 t.budgetprincipal, t.loanimpulse, t.depositimpulse, t.stafftype, t.confirmStatus, t.oppstep 
				  ,u.username as perusername,u.deptid as perdeptid,u.deptname as perdeptname 
				  FROM t_budget_reimbursement t 
				  LEFT JOIN t_sys_mnguserinfo u ON t.userid = u.userid 
				  WHERE (t.depid IN (
				 select unitid from (( SELECT DISTINCT (datascope.unitid) FROM roledatascope AS datascope WHERE datascope.roleid IN 
				 ( SELECT userrole.role_id FROM t_sys_mnguserrole AS userrole WHERE userrole.user_id =:userid ) AND datascope.moduleaction LIKE :requestUrl 
				 ) as t_tmp_datascope ))OR t.depid =:deptid) 