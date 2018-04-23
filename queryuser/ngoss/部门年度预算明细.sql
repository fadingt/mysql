	select 
		t.budgetid,
		t.budgetno, -- 预算编号
		t.budgetname, -- 预算名称
		t.budgettype, -- 预算类型
		(select remark4 from t_sys_mngunitinfo where unitid = t.departmentid) as departmentname , -- 部门名称
		t.startdate, -- 开始日期
		t.enddate, -- 结束日期 
		t.budgetdescription, -- 预算描述
		t.budgetamount, -- 预算费用总金额
		t1.totalused, -- 已使用预算金额
		u.unitname as companyname, -- 公司名称
		ifnull(r.ramt,0) ramt, -- 预计人力成本
		x.yearmonth,
		ifnull(x.usedcost,0)usedcost, -- 已使用人力成本
		z.username as chargepersonname  -- 预算负责人
	from t_budget_deptannualbudget t
	left join t_sys_mnguserinfo z on z.userid = t.chargeperson
	left join t_sys_mngunitinfo u on u.unitid = t.company
	left join
	(
			select 
				budgetid,sum(totalused) as totalused
			from t_budget_selfbudget
			where budgetcategory = '04'
			GROUP BY budgetid
	) t1 on t.budgetid = t1.budgetid 
	left join (
			select 
				budgetid,
				deptid,
				sum(infoex2) ramt -- 人力
			from  t_budget_deptlevelcost
			GROUP BY budgetid
	)r on r.budgetid=t.budgetid 
	left join
	(
		select
			ifnull(cast(sum(workdays*defaultcost) as decimal(12,2)),0) as usedcost ,targetid,yearmonth
		from 
		(  
			select 
				sum(workdays) as workdays,employeeid,targetid,yearmonth
			from
			( 
				select
					FORMAT(sum(workhours)/8,2) as workdays,employeeid,targetid,left(yearmonthday,6) yearmonth 
				from t_project_workhourmanager  
				where workhourtype=2 and status = 3 
				GROUP BY employeeid,targetid,left(yearmonthday,6)

				UNION ALL 

				select 
					FORMAT(sum(workhours)/8,2) as workdays,employeeid,targetid,left(yearmonthday,6) yearmonth
				from t_project_workhourmanager  
				where workhourtype=2  and status = 2 
				GROUP BY employeeid,targetid,left(yearmonthday,6)
			) x 
			GROUP BY employeeid,targetid,yearmonth	 
		)a 
		LEFT JOIN t_sys_mnguserinfo m on employeeid = userid
		LEFT JOIN t_public_levelcost cost on staf_leve = postlevel 
		GROUP BY targetid,yearmonth
	) x on x.targetid=t.budgetid

	where t.budgetnature='1'
	-- {budgetno}
	-- {inputdate}
	-- {department}
	-- {budgetname}
	order by budgetno