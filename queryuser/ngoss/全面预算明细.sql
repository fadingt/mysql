select 
x.*,
t.remark4 deptname, t.linename, t.calcdept,-- 预算部门 条线 核算部门 
sqys.buno beiyong from (
-- select  type,budgetno,budgetname,unitid,chargeperson,jianliren,yearmonth, IFNULL(fy,0) fy, IFNULL(sjfy,0) sjfy, IFNULL(gz,0) gz, IFNULL(sjgz,0) sjgz ,year 
-- from (
select  
type,
typevalue,
tall.budgetid,
tall.budgetno,
tall.budgetname,
tall.unitid,
chargeperson,
jianliren,
-- gfamt,
-- gfamty,
-- gramt,
-- gramty,
tall.year,
t1.yearmonth,
gfamt, -- 费用总额度
fy gfamty,-- 已提交的费用
sjfy,-- 已使用的费用
gramt, -- 人天总额
gz,-- 标准成本
sjgz-- 实际成本

from (

	select tf.budgetid,'管理预算' as type,2 as typevalue,ifnull(budgetno,'无编号') budgetno,budgetname,departmentid unitid ,getusername(chargeperson) chargeperson, jianliren, gfamt,gramt,tf.year  
	from  
		(select tt.budgetid,budgetno,budgetname,departmentname as deptname, chargeperson,getusername(registerid) jianliren,budgetamount gfamt,tt.infoex2 gramt,departmentid,left(createtime,4) year  from  t_budget_deptannualbudget t
	LEFT JOIN  t_budget_deptlevelcost tt on t.budgetid=tt.budgetid 
	) tf 
	UNION all -- ==================================================================================
	select projectid,'管理预算' as type,0 as typevalue,tall.projectno,tall.projectname,tall.deptid,tall.ysfuzeren,tall.yscjren,tall.dfamt,tall.dramt,tall.year
	from (
	select 
		p.projectid,
		ifnull(costtotal,0)+ifnull(purchaseproductcost,0)+ifnull(purchaseservicecost,0) dfamt,
		basiccosttotal dramt,
		projectno,
		projectname,
		getusername(pd)ysfuzeren,
		getusername(createid) yscjren,
		deptid ,
		left(t.createtime,4) year
	from t_project_developbudget t,t_project_projectinfo p WHERE t.projectid=p.projectid AND p.projecttype=8
		 )tall   

	UNION ALL -- ==================================================================================

	select projectid,'研发预算' as type,0 as typevalue,tall.projectno,tall.projectname, (tall.deptid)deptname,tall.ysfuzeren,tall.yscjren,tall.dfamt,tall.dramt,tall.year
	from (
		select 
			p.projectid,
			ifnull(costtotal,0)+ifnull(purchaseproductcost,0)+ifnull(purchaseservicecost,0) dfamt,
			basiccosttotal dramt,
			projectno,
			projectname,
			getusername(pd)ysfuzeren,
			getusername(createid) yscjren,
			deptid ,
			left(t.createtime,4) year
		from t_project_developbudget t,t_project_projectinfo p WHERE t.projectid=p.projectid AND p.projecttype=5 
		 )tall 

	UNION ALL   -- ==================================================================================
	select tall.budgetid,'销售预算' as type, 3 as typevalue,t1.extend1,t1.budgetname, (tall.unitid),t1.budgetprincipalname,t1.username,tall.salelimit mfamt,tall.saledayscost mramt,tall.year
	 from (select * from t_sale_marketingbudget where year=2018) tall
	left JOIN (
	select * from 
	t_budget_selfbudget where budgetcategory=01 and budgettype = '11' and left(enddate,4)=2018 )t1
	on tall.userid = t1.userid

	UNION ALL -- ==================================================================================

	select presaleid,'售前预算' as type,1 as typevalue,presaleno,businessname, (tall.deptid),principalname,getusername(userid),predictexpense as  pfamt,infoex3 as pramt,tall.year from T_Sale_Presales tall
)tall

LEFT JOIN ( --  已提交费用
	select 
	extend1,
	sum(totalused) fy,
	budgetdeptid
	from t_budget_selfbudget  -- where extend1 like '%qt%' or extend1 like '%BM%' 
	GROUP BY extend1

)t0 on  t0.extend1 = tall.budgetno

left join -- 标准成本 工资（已提交人天）
(
SELECT 
	budgetid, budgetname, budgetno,
	SUM(gz) gz, yearmonth
	FROM `t_project_standardcost_gz`
	where gzcourse = 64010501
-- and yearmonth >= 201801
	GROUP BY budgetid, yearmonth
) t1 on t1.budgetid = tall.budgetid

left join -- 实际成本 工资
(
	SELECT 
	budgetid, budgetno, budgetname,
	SUM(gz) sjgz, yearmonth
	FROM `t_project_standardcost_sjgz`
	GROUP BY budgetid, yearmonth
) t2 on t2.budgetid = tall.budgetid and t2.yearmonth = t1.yearmonth

left join -- 已记账费用
(
	SELECT
		extend1,-- 预算编号 类型
		year, month, CONCAT(year,month) yearmonth,-- 费用发生年月
		SUM(amt) sjfy
	from t_report_cost_voucher_fy
	where left(course, 1) = '*'
	GROUP BY extend1, CONCAT(year,month)
) t3 on t3.extend1 = tall.budgetno and t3.yearmonth = t1.yearmonth
-- )xx 

where 1=1  
-- and (gfamt is not null or gramt is not null)
and tall.year = 2018

)x
LEFT JOIN (SELECT unitid, remark4, lineid, linename, calcdept from t_sys_mngunitinfo WHERE isdel =0 ) t on x.unitid = t.unitid
LEFT JOIN (SELECT presaleid, presaleno, projbusinessno buno FROM T_Sale_Presales) sqys on sqys.presaleno = x.budgetno
where 1=1
-- {unitid}
-- {deptname}
-- {type}
-- {year}
-- {budgetno}
-- {budgetname}