SELECT
	cbbusinessid,'销售预算' type, 3 as typevalue, businessno,businessname,
	deptid unitid, cbprincipalname, cbapplyusername,
	ysze gfamt,-- 预算费用总额
	salecost-- 预算人工总额
FROM
(
		SELECT 
				businessid cbbusinessid,-- 客户商机ID
				businessno,-- 客户商机编号
				custid cbcustid,-- 客户ID
				businessname,-- 客户商机名称
				deptid, deptname,
				predictsumprice,-- 预计总价
				year cbyear,-- 商机年度
				status cbstatus,--  '状态(1-未生效，2-已生效，3-变更中)',IDFS000079
				getcustname(custid) custname,-- 客户名称
				applyfigure,-- 客户商机金额
				createdate cbcreatedate,-- 创建时间
				salecost,-- 预算人工总额
				getusername(applyuserid) cbapplyusername,
				getusername(principal) cbprincipalname
		from t_sale_customerbusiness
) cb
left join `t_report_custsummary` c on c.businessid = cb.cbbusinessid and c.`year` = cb.`cbyear`
