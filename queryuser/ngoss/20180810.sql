SELECT
		a.*,
		SUM(case when b.invoicetype = 3 then b.bta else b.amt end) as amt,--  报销总金额
-- 		GROUP_CONCAT(b.content) content,-- 	报销说明
		c.billno, c.acctdate, c.acctregistername, c.acctstatus,
		d.approveusers, d.COMPLETEDDATE, d.CREATEDDATE
-- ''
from (
	SELECT
		id, applydate, -- 报销单日期
		reimbursementno,-- 报销单编号
		getusername(userid) applyuser,-- 申请人
		amount,--  报销总金额
		invoicecount, -- 发票总张数
		figuredestname, --  费用目标名称	(发票抬头)
		paymentid
	from t_budget_reimbursement 
	where paymentid is not null 
)a
join (
	SELECT
		invoicetype, reimbursementid, bta, amt, content
	from t_budget_reimbursementdetail
	where course not in (161,163) 
)b on a.id = b.reimbursementid
join (
	SELECT 
			id, billno, acctdate, paymentdate, getusername(acctregister) acctregistername,
			case when acctstatus = 0 then '未记账' when acctstatus = 1 then '已记账' else '不知道' end acctstatus
	from t_budget_paymentbill a
) c on a.paymentid = c.id
join(
	SELECT
		a.businessid, a.processdefinitionid, a.processinstanceid, a.assignmentid, a.opinion,
		b.approveusers, c.COMPLETEDDATE, c.CREATEDDATE
	from bpm_workflowbusiness a
	join (
		SELECT MAX(assignmentid) maxassignmentid, GROUP_CONCAT(b.username) approveusers
		from bpm_workflowbusiness a, t_sys_mnguserinfo b
		where processdefinitionid = 'ReimbursementForApproval_vv_1' and a.userid = b.userid
		GROUP BY processinstanceid
	) b on a.assignmentid = b.maxassignmentid
	left join bpm_processinstance c on a.processinstanceid = c.processinstanceid
	where a.processdefinitionid = 'ReimbursementForApproval_vv_1' and `status` = 10
) d on CONCAT('{"id":"', a.id ,'"}') = d.businessid
GROUP BY a.id
having SUM(case when b.invoicetype = 3 then b.bta else b.amt end) < 500

-- 54957
-- 支付凭单编号 记账人	记账日期
-- 审核人	审核日期	报销单最后审核日期


-- SELECT *
-- FROM report_reimbursement_paymentbill a
-- left join(
-- SELECT
-- a.businessid, a.processdefinitionid, a.processinstanceid, a.assignmentid, a.opinion,
-- b.approveusers, c.COMPLETEDDATE, c.CREATEDDATE
-- from bpm_workflowbusiness a
-- join (
-- SELECT MAX(assignmentid) maxassignmentid, GROUP_CONCAT(b.username) approveusers
-- from bpm_workflowbusiness a, t_sys_mnguserinfo b
-- where processdefinitionid = 'ReimbursementForApproval_vv_1' and a.userid = b.userid
-- GROUP BY processinstanceid
-- ) b on a.assignmentid = b.maxassignmentid
-- left join bpm_processinstance c on a.processinstanceid = c.processinstanceid
-- where a.processdefinitionid = 'ReimbursementForApproval_vv_1' and `status` = 10
-- ) b on CONCAT('{"id":"', a.reimid ,'"}') = b.businessid