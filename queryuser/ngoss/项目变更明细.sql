	SELECT
		b.projectno, b.projectname, d.salename, d.salearea,
		CONCAT(b.yearmonth,'->',c.yearmonth) `yearmonth`,
		case when b.company != c.company then CONCAT(b.company,'->',c.company) 
		when b.company is null then CONCAT('->',c.company)
		when c.company is null then CONCAT(b.company,'->')
		else b.company end 'company',
		case when b.projecttype != c.projecttype then CONCAT(b.projecttype,'->',c.projecttype)
		when b.projecttype is null then CONCAT('->',c.projecttype)
		when c.projecttype is null then CONCAT(b.projecttype,'->')
		else b.projecttype end 'projecttype',
		case when b.businesstype != c.businesstype then CONCAT(b.businesstype,'->',c.businesstype)
		when b.businesstype is null then CONCAT('->',c.businesstype)
		when c.businesstype is null then CONCAT(b.businesstype,'->')
		else b.businesstype end 'businesstype',
		case when b.prjstatus != c.prjstatus then CONCAT(b.prjstatus,'->',c.prjstatus)
		when b.prjstatus is null then CONCAT('->',c.prjstatus)
		when c.prjstatus is null then CONCAT(b.prjstatus,'->')
		else b.prjstatus end 'prjstatus',
		case when b.incometype != c.incometype then CONCAT(b.incometype,'->',c.incometype)
		when b.incometype is null then CONCAT('->',c.incometype)
		when c.incometype is null then CONCAT(b.incometype,'->')
		else b.incometype end 'incometype',
		case when b.startdate != c.startdate then CONCAT(b.startdate,'->',c.startdate)
		when b.startdate is null then CONCAT('->',c.startdate)
		when c.startdate is null then CONCAT(b.startdate,'->')
		else b.startdate end 'startdate',
		case when b.enddate != c.enddate then CONCAT(b.enddate,'->',c.enddate)
		when b.enddate is null then CONCAT('->',c.enddate)
		when c.enddate is null then CONCAT(b.enddate,'->')
		else b.enddate end 'enddate',
		case when b.maintaincedate != c.maintaincedate then CONCAT(b.maintaincedate,'->',c.maintaincedate)
		when b.maintaincedate is null then CONCAT('->',c.maintaincedate)
		when c.maintaincedate is null then CONCAT(b.maintaincedate,'->')
		else b.maintaincedate end 'maintaincedate',
		case when b.budgetcontractamout != c.budgetcontractamout then CONCAT(b.budgetcontractamout,'->',c.budgetcontractamout)
		when b.budgetcontractamout is null then CONCAT('->',c.budgetcontractamout)
		when c.budgetcontractamout is null then CONCAT(b.budgetcontractamout,'->')
		else b.budgetcontractamout end 'budgetcontractamout'
	from (
			SELECT 
				projectid, projectno, projectname, yearmonth, getunitname(company) company,
				translatedict('IDFS000091',projecttype) projecttype,
				translatedict('IDFS000092',businesstype) businesstype,
				translatedict('IDFS000070',prjstatus) prjstatus,
				translatedict('IDFS000071',incometype) incometype, 
				startdate, enddate, maintaincedate,  budgetcontractamout
			from t_income_prjmonthincome_prjstatic a
			JOIN (
				SELECT MAX(yearmonth) AS yearmonth1
					, DATE_FORMAT(DATE_SUB(CONCAT(MAX(yearmonth), '01'), INTERVAL 1 MONTH), '%Y%m') AS yearmonth2
				FROM t_income_prjmonthincome_prjstatic
			) b
			on a.yearmonth = b.yearmonth2
	)b,
	(
			SELECT 
				projectid, projectno, projectname, yearmonth, getunitname(company) company,
				translatedict('IDFS000091',projecttype) projecttype,
				translatedict('IDFS000092',businesstype) businesstype,
				translatedict('IDFS000070',prjstatus) prjstatus,
				translatedict('IDFS000071',incometype) incometype, 
				startdate, enddate, maintaincedate,  budgetcontractamout
			from t_income_prjmonthincome_prjstatic a
			JOIN (
				SELECT MAX(yearmonth) AS yearmonth1
					, DATE_FORMAT(DATE_SUB(CONCAT(MAX(yearmonth), '01'), INTERVAL 1 MONTH), '%Y%m') AS yearmonth2
				FROM t_income_prjmonthincome_prjstatic
			) b
			on a.yearmonth = b.yearmonth1
	)c,
(
			SELECT
				projectid, saleid, getusername(saleid) salename,
				(SELECT getunitname(parentunitid) from t_sys_mngunitinfo where unitid = (SELECT deptid from t_sys_mnguserinfo WHERE userid = saleid)) salearea
			from t_project_projectinfo
			where SUBSTRING_INDEX(projectno,'-',1) = 'YY'
)d
where b.projectid = c.projectid and b.projectid = d.projectid
and (
	b.projecttype <> c.projecttype || b.businesstype <> c.businesstype || b.prjstatus <> c.prjstatus || b.incometype <> c.incometype || b.startdate <> c.startdate || b.enddate <> c.enddate || b.maintaincedate <> c.maintaincedate || b.budgetcontractamout <> c.budgetcontractamout
)
and SUBSTRING_INDEX(b.projectno,'-',1) = 'YY'
-- {salename}{salearea}{projectno}
ORDER BY b.projectid