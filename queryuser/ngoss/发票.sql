select 
*
from (
	SELECT
		id, relationid,
		protocolorcontractid, stageid, orderid, orderstageid,
		case when stageid is not null then 0 else 1 end as textend1, -- 0 固定金额 1 框架协议
		IFNULL(stageid,orderstageid) tstageid,
		billingno,-- 开票编号
		billingtype,-- 开票类型
		getunitname(company)company ,-- 签约客户
		title,-- 发票抬头
		billamount,-- 开票金额（含税）
		billamounnotax,-- 开票金额（不含税）
		billtype,-- 发票类型
		applytime,-- 发票申请时间
		saleid, getusername(saleid) sale,-- 所属销售
		opertype,-- 操作类型
		invoicestatus,-- 录入发票状态
		invoiceinputdate-- 录入发票时间
	from t_bill_main 
) t
join (
	SELECT
		contractid,
		contractno,-- 合同编号
		contractname-- 合同名称
	from t_contract_main 
) t1 on t.relationid = t1.contractid
left join (
	select
		billingid,
		invoiceno, -- 发票编号
		invoicecontent, -- 发票内容
		invoicetime, -- 发票时间
		invoiceamt, -- 发票金额（含税）
		invoiceamtnotax, -- 发票金额（不含税）
		invoicestatus as  invoicestatus1
	from t_bill_Invoice
	where invoicestatus=0
) t2 on t.id = t2.billingid
left join (
	SELECT 
		extend1 bextend1, stageid bstageid, projectid bprojectid, projectstageid
	from t_contract_project_stage
) b on t.textend1 = b.bextend1 and t.tstageid = b.bstageid
left join (
	SELECT
		a.projectid, a.projectno, a.projectname, a.templateid, projectstep, a.ybillamt, a.ybilldate
	from t_project_stage_ys_tian a
) a on b.bprojectid = a.projectid and b.projectstageid = a.templateid

where 1=1
-- {company}
-- {title}
-- {sale}
-- {invoicestatus}
