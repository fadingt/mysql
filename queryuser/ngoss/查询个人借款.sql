SELECT
x.*,
budget.*
FROM
(
			SELECT
				loanid,
				companyid companyname,--  财务主体
			-- 员工编号
				userid,
				getusername(userid) username,-- 员工姓名
				deptid,
				unit.remark4 deptname, -- 员工所属部门
				unit.brno, -- 部门编号
				loanno,-- 借款单号
				loanfigure,-- 支付金额
				paymentdate, -- 支付日期
				loantype,-- 借款类型
				loaddescription,-- 借款说明
				budgetid,budgetcategory,budgettype,	budgetname,-- 预算名称
				translateseconddict('loanbudgettype',budgetcategory,budgettype) btype,
				paymentstatus,
				(CASE loanstatus WHEN 1 THEN '草稿' WHEN 2 THEN '待审批' WHEN 3 THEN '审批通过' WHEN 4 THEN '已驳回' END) loanstatus
			-- IDFS000116
			FROM t_budget_loaninfo a
			join t_sys_mngunitinfo unit on a.deptid = unit.unitid
			WHERE paymenttype != 2
-- 			{username}{loanno}
-- 			{startdate}{enddate}
-- 			{loanstatus}{loantype}{paymentstatus}

)x
		left join(
				SELECT 
					budgetid budgetid2, extend1 beiyong, budgetname budgetname2,
					budgetcategory budgetcategory2, budgettype budgettype2
				from t_budget_selfbudget
				WHERE extend1 is not null
				GROUP BY budgetid, budgetcategory, extend1
		) budget on x.budgetid = budget.budgetid2 and x.budgetcategory = budget.budgetcategory2 and x.budgettype = budget.budgettype2

where 1=1
--  {companyname}{beiyong}
ORDER BY x.userid


-- left JOIN
-- (
-- 		SELECT	
-- 				projectid , projectno beiyong, projectname `name`,'03' as budgetcategory2, 
-- 				case SUBSTRING_INDEX(projectno,'-',1) when 'YY' then '31' when 'YF' then '32' else '33' end as budgettype2
-- 		from t_project_projectinfo
-- ) project on project.projectid = x.budgetid and project.budgetcategory2 = x.budgetcategory