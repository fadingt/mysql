set @year = 2018;
select
		t.*, p.*, x.*,
		(case year when 2016 then 0 else  IFNULL((SELECT SUM(year_taxfree) FROM t_income_prjmonthincome_year WHERE year <@year and projectid = t.projectid and company = t.company group by projectid, company),0) END) qc_taxfree,
		(case year when 2016 then year_taxfree else IFNULL((SELECT SUM(year_taxfree) FROM t_income_prjmonthincome_year WHERE  projectid = t.projectid and company = t.company and year <= @year group by projectid, company),0)  END) qm_taxfree,
		getunitname(t.company) companyname
from (
		SELECT * from t_income_prjmonthincome_year
		WHERE `year` = @year
-- 		{projectno}{projectname}{companyname}
) t
join (
		SELECT
			projectid pprojectid, projstatus,
			getcustname(finalcustomer) custname, -- 客户名称
			translatedict('IDFS000070', projstatus) projstatusname, -- 项目状态
			translatedict('IDFS000092', businesstype) projecttypename,-- 项目类型 
-- 			predictincome, budgetcontractamout,-- 预算收入 预算合同金额
			DATE_FORMAT(predictstartdate,'%Y-%m-%d') predictstartdate, -- '预计开始日期',
			DATE_FORMAT(predictenddate,'%Y-%m-%d') predictenddate, -- '预计结束日期',
			DATE_FORMAT(maintenancedate,'%Y-%m-%d') maintenancedate -- '维护结束日期',
		FROM t_project_projectinfo
-- 		where 1=1 {projstatus}
) p on p.pprojectid = t.projectid
join (
		SELECT 
			a.projectid projectidx, a.company companyx, a.yearmonth, left(a.yearmonth,4) yearx,
			a.budgetcontractamout, a.budgetincome, a.predictcost, a.contractstatus, a.incometype-- IDFS000071
		from t_income_prjmonthincome_fi a
		join (
				SELECT projectid, MAX(yearmonth) yearmonth, company
				from t_income_prjmonthincome_fi
				GROUP BY projectid, company, left(yearmonth,4)
		) b on a.projectid = b.projectid and a.company = b.company and a.yearmonth = b.yearmonth
		WHERE left(a.yearmonth, 4) = @year
) x on x.projectidx = t.projectid and x.companyx = t.company

order by company, projectno
;