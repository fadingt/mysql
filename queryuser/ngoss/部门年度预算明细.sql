select 
	t.*,
	t1.totalused, -- 已使用预算金额
	ifnull(r.ramt,0) ramt, -- 预计人力成本
	x.yearmonth,
	ifnull(x.usedcost,0)usedcost -- 已使用人力成本
from
(
	select 
		budgetid, budgetno, budgetname, budgettype, budgetdescription,budgetnature,-- 预算编号 名称 类型 描述
		SUBSTRING_INDEX(getLevelDeptNameByTian(departmentid),'-',2) departmentname , -- 所属部门名称
		startdate, enddate, -- 开始结束日期 
		budgetamount, -- 预算费用总金额
		getusername(chargeperson) chargepersonname, getunitname(company) companyname-- 预算负责人 公司名称
	from t_budget_deptannualbudget

) t 
LEFT JOIN
(
	select
		budgetid, sum(totalused) as totalused
	from t_budget_selfbudget
	where budgetcategory = '04'
	GROUP BY budgetid
) t1 on t.budgetid = t1.budgetid 
left join 
(
	select 
		budgetid, deptid, sum(infoex2) ramt -- 人力
	from  t_budget_deptlevelcost
	GROUP BY budgetid
)r on r.budgetid=t.budgetid 

left join (

	select 
		ifnull(cast(sum(workdays*defaultcost) as decimal(12,2)),0) as usedcost ,targetid,yearmonth
	from (  
		select sum(workdays) as workdays,employeeid,targetid,yearmonth
		from 	
		( 
-- 已通过的考勤
				select 
				FORMAT(sum(workhours)/8,2) as workdays,employeeid,targetid,left(yearmonthday,6) yearmonth 
				from t_project_workhourmanager  
				where workhourtype=2 and status = 3 
				GROUP BY employeeid,targetid,left(yearmonthday,6)

				UNION ALL 

-- 待审批的考勤
				select FORMAT(sum(workhours)/8,2) as workdays,employeeid,targetid,left(yearmonthday,6) yearmonth 
				from t_project_workhourmanager  
				where workhourtype=2 and status = 2 
				GROUP BY employeeid,targetid,left(yearmonthday,6)
				) x GROUP BY employeeid,targetid,yearmonth
		 )a 
	LEFT JOIN t_sys_mnguserinfo m on employeeid = userid
	LEFT JOIN t_public_levelcost cost on staf_leve = postlevel 
	GROUP BY targetid,yearmonth
) x on x.targetid=t.budgetid

left join
(
	SELECT 
	budgetid, budgetno, budgetname, SUM(gz) gramty2, yearmonth
	FROM `t_project_standardcost_sjgz`
	GROUP BY budgetid, yearmonth
) x2 on x2.budgetid = t.budgetid

where 1=1
and t.budgetnature = '1'
-- {budgetno}
-- {inputdate}
-- {department}
-- {budgetname}
 order by budgetno