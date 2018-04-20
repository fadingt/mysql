SELECT *
FROM
(
		SELECT *, COUNT(processinstanceid) cnt
		FROM
		(
				SELECT DISTINCT
				businessid, processinstanceid, userid
				FROM bpm_workflowbusiness
				WHERE processdefinitionid = 'ReimbursementForApproval_vv_1' 
							AND assignmentname != 'config_2_二级审批'
							-- AND assignmentname != 'start_1_提交'
							-- AND businessid = '{"id":"192"}'
				AND processinstanceid not in
														(
															SELECT DISTINCT processinstanceid
															FROM bpm_workflowbusiness
															WHERE processdefinitionid = 'ReimbursementForApproval_vv_1' AND status != 10
														)
		) t
		GROUP BY processinstanceid
) tt
JOIN 
(
		SELECT id, reimbursementno, amount, paymentid, invoicecount, createtime, applydate,
					(CASE WHEN extend1='' OR extend1 is null THEN budgetid ELSE extend1 end), budgetname, getusername(userid), 
					unitname,
					'|'
		FROM t_budget_reimbursement r
		WHERE approvalstatus = 3
) reim ON CONCAT('{"id":"', reim.id, '"}') = tt.businessid
-- WHERE businessid = '{"id":"203"}';
LEFT JOIN 
(
		SELECT 
			id,
			reimbursements,
			billno,
			payamount,
			unitname,
			paymentdate,
			acctstatus
		FROM t_budget_paymentbill
) voucher ON reim.paymentid = voucher.id

WHERE cnt = 1
ORDER BY billno, reim.id

;
/*
SELECT
*,
assignmentname,
businessid,
processinstanceid,
assignmentid,
opinion,
businessstatus
FROM bpm_workflowbusiness
WHERE processdefinitionid = 'ReimbursementForApproval_vv_1' 
			AND businessid = '{"id":"38024"}'
;
*/