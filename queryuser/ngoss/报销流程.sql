
SELECT
reim.reimbursementno,
t.*
FROM
(
		SELECT DISTINCT
			processinstanceid, userid
		FROM bpm_workflowbusiness
		WHERE  processdefinitionid = 'ReimbursementForApproval_vv_1' and processinstanceid = 
		(
				SELECT
					*
				FROM bpm_workflowbusiness
				WHERE processdefinitionid = 'ReimbursementForApproval_vv_1'
				AND processinstanceid in
				(
						SELECT MAX(CAST(processinstanceid AS signed))
						FROM bpm_workflowbusiness
						WHERE processdefinitionid = 'ReimbursementForApproval_vv_1'
									 -- AND businessid = '{"id":"203"}'
						GROUP BY businessid
				)
				AND status = 10
		) 
)t
JOIN 
(
		SELECT id, reimbursementno, amount
		FROM t_budget_reimbursement
		WHERE approvalstatus = 3
) reim ON CONCAT('{"id":"', reim.id, '"}') = t.businessid
WHERE businessid = '{"id":"203"}';


SELECT * FROM bpm_workflowbusiness
WHERE processdefinitionid = 'ReimbursementForApproval_vv_1' AND businessid = '{"id":"203"}'
