		SELECT
			project.S_PRJNO `项目编号`, t.yearmonth `年月`,
			IFNULL(standardcost,0) `标准成本`,
			IFNULL(realcost,0) `实际成本`, 
			IFNULL(realfee,0) `实际费用`, 
			IFNULL(realpur,0) `实际采购`,
			IFNULL(income.income,0) `实际收入`, IFNULL(income.tax,0) `销项税`,
			IFNULL(cumulativecost,0)+IFNULL(realcost,0)+IFNULL(realfee,0)+ IFNULL(realpur,0) + IFNULL(qc.`2019期初累计成本`,0)`累计成本`, 
			IFNULL(cumulativeincome,0)+IFNULL(income.income,0) + IFNULL(qc.`2019期初累计收入`,0) `累计收入`,
			budgetincome `预计收入`, project.DL_BUDCOAMTI `预算合同额`,
			ngoss.translatedict('taxrate',project.S_TAXRATE) `税率`
/*
			project.S_PRJNAME `项目名称`,
			ngoss.getfullorgname(project.s_dept) `项目所属部门`,
			ngoss.translatedict('prjclass',project.S_PRJCLASS) `项目分类`,
			-- cont.contype `项目类型`,
			ngoss.translatedict('prjstatus',project.S_PRJSTATUS)`项目状态`,
			ngoss.translatedict('ApproStatus',project.S_APPSTATUS) `审批状态`,
			ngoss.translatedict('OPERTYPE', project.S_OPERTYPE) `操作类型`,
			ngoss.translatedict('PBaseType',project.S_BASEFULL) `依据状态`,
			ngoss.translatedict('INCOMEWAY', project.S_INCOMEWAY) `收入确认方式`,
			ngoss.getusername(project.S_MANAGER) `项目经理`,
			ngoss.getusername(project.S_DIRECTOR) `项目总监`,
			ngoss.getcustname(buz.I_CUSTID) `客户名称`,
			ngoss.getusername(buz.S_SALEMAN) `销售代表`,
			ngoss.getusername(cust.S_FIRTECH) `客户经理a`,
			ngoss.getusername(cust.S_SECTECH) `客户经理b`,
			DT_SETUPTIME `项目创建日期`,
			project.DT_STARTTIME `项目开始日期`,
			project.DT_ENDTIME `项目结束日期`,
			project.DT_MAINEND  `项目维保期`,
			project.DL_BUDCOAMTI `立项金额`
*/
		from mdl_aos_project project
		left join (
			SELECT 
			projectid, projectno, projectname, 
			SUM(cumulativecost) `2019期初累计成本`, 
			SUM(cumulativeincome) `2019期初累计收入`
			from t_snap_income_projectinfo
			where yearmonth = 201812
			GROUP BY projectid
		) qc on qc.projectid = project.ID
		join (
			SELECT DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') yearmonth
			from mdl_aos_canlender
			where DATE_FORMAT(DT_CANDAY,'%Y%m') BETWEEN 201901 and DATE_FORMAT(NOW(),'%Y%m')
		)t
		left join (
			SELECT SUM(amt) realcost, yearmonth, budgetno
			FROM `t_snap_fi_standardcost`
			where budgetno like 'yy%' and isactingstd = 0
			and type = 4 -- 实际工资
			GROUP BY budgetno, yearmonth
		)sjcb on sjcb.yearmonth = t.yearmonth and sjcb.budgetno = project.s_prjno
		left join (
			SELECT SUM(amt) standardcost, yearmonth, budgetno
			FROM `t_snap_fi_standardcost`
			where budgetno like 'yy%' and isactingstd = 1
			and type in (1,2)-- 标准工资
			and account = '6401'
			GROUP BY budgetno, yearmonth
		)cost on cost.budgetno = project.s_prjno and cost.yearmonth = t.yearmonth
		left join (
			SELECT SUM(debit) as realfee,CONCAT(`year`,`month`) as yearmonth, budgetno
			from t_snap_fi_voucher
			where 1=1
			and budgetno like 'yy%' and dc = '01' and zzno = '6401'
			and year is not null and month is not null
			and mxno not in (640133,640134)
			GROUP BY budgetno, CONCAT(`year`,`month`)
		)sjfy  on sjfy.budgetno = project.s_prjno and sjfy.yearmonth = t.yearmonth
		left join (
			SELECT SUM(debit) as realpur,CONCAT(`year`,`month`) as yearmonth, budgetno
			from t_snap_fi_voucher
			where 1=1
			and budgetno like 'yy%' and dc = '01' and zzno = '6401'
			and year is not null and month is not null
			and mxno in (640133,640134)
			GROUP BY budgetno, CONCAT(`year`,`month`)
		)Purchase  on Purchase.budgetno = project.s_prjno and Purchase.yearmonth = t.yearmonth
		left join (
			SELECT 
				projectid, projectno, yearmonth, budgetincome, budgetcontractamt,
				SUM(curmonincome+adjustincome) income, SUM(curmontax+adjusttax) tax,
				SUM(cumulativecost) cumulativecost, SUM(cumulativeincome) cumulativeincome,
				incometypename			
			from t_snap_income_projectincome_final
			GROUP BY projectid, yearmonth
		) income on income.projectid = project.ID and income.yearmonth = t.yearmonth

		where project.IS_DELETE = 0
		GROUP BY project.ID, t.yearmonth