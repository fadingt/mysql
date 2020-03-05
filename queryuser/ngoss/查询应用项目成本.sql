select
*,
(dnsr - dnrl - dnfee - dncg)/dnsr profitrate1
from (
	select  
			t.*,
			getunitname(gatheringunitid) company,
			getcustname(signedcustomer) signcust,
			getcustname(finalcustomer) finalcust,
-- 			ifnull(budgetcontractamout,0) contractprice,
			(SELECT getunitname(parentunitid) from t_sys_mngunitinfo where unitid = (SELECT deptid from t_sys_mnguserinfo WHERE userid = saleid)) salearea,
			translatedict ('IDFS000070', projstatus) projstatusname,
			translatedict ('IDFS000091', projecttype) projecttypename,
			translatedict ('IDFS000092', businesstype) businesstypename
	from 
		t_report_projectinfoinout t
	where projectno like '%yy%'-- and projstatus != 6
-- {projectno}
-- {projectname}
-- {nowyear}
-- {pmname}
-- {pdname}
-- {projectlinename}
-- {projectlinepersonname}
-- {deptid}
) x

join  
(
	SELECT 
		projectid projectid1, predictstartdate predictstartdate1, predictenddate predictenddate1, maintenancedate maintenancedate1, 
		getusername(b.tecpersonid) techperson,-- 客户经理/项目技术负责人
		case 
			(SELECT COUNT(projectid) from t_contract_projectrelation where projectid = a.projectid GROUP BY projectid)
		when 0 then 0 -- 未签约
		else 1 -- 已签约 IDFS000242
		end signstatus,
		ifnull(budgetcontractamout,0) contractprice,
		SUBSTRING_INDEX(translateseconddict('JSLY',technologyarea,technologyarea2),'-', 1) techarea1, -- 解决方案
		SUBSTRING_INDEX(translateseconddict('JSLY',technologyarea,technologyarea2),'-', -1) techarea2 -- 解决方案子类
	from
		`t_project_projectinfo` a,
		`t_sale_custbasicdata` b
	where 
		a.finalcustomer = b.custid
		and projectno like '%yy%'-- and projstatus != 6
) x1 on x.projectid = x1.projectid1

LEFT JOIN
(
	SELECT
		projectid projectid2,
		sum(case WHEN `year` < t.query_year then year_income else 0 end) wnsr,-- 往年收入
		sum(case when `year` = t.query_year then year_income else 0 end) dnsr,-- 当年收入
		sum(case when `year` <= t.query_year then year_income else 0 end) ljsr-- 累计收入	
	FROM
		(
			SELECT projectid, SUM(curmonincome+adjustincome+taxfreeincome) year_income, left(yearmonth,4) `year`
			from t_income_prjmonthincome_fi 
			GROUP BY projectid, `year`
		) fi,
		(SELECT DATE_FORMAT(NOW(),'%Y') query_year from DUAL) t
	GROUP BY projectid
) x2 on x.projectid = x2.projectid2

LEFT JOIN
(
	SELECT
		projectid projectid3,	sum(sbillamt) kp,	sum(sreceamt) hk, SUM(yreceamt) f_contractprice
	from t_project_stage_ys_tian
	GROUP BY projectid
) x3 on x.projectid = x3.projectid3

LEFT JOIN
(
SELECT
		projectid,
		SUM(yjcb_cg) precg, -- 预计总采购成本
		sum(case WHEN nowyear < t.query_year then purchasecost else 0 end) wncg,-- 往年总采购成本
		sum(case when nowyear = t.query_year then purchasecost else 0 end) dncg,-- 当年采购成本
		sum(case when nowyear <= t.query_year then purchasecost else 0 end) ljcg,-- 累计采购成本
		SUM(fee) prefee, -- 预计总费用
		sum(case WHEN nowyear < t.query_year then realfee else 0 end) wnfee,-- 往年实际费用
		sum(case when nowyear = t.query_year then realfee else 0 end) dnfee,-- 当年实际费用
		sum(case when nowyear <= t.query_year then realfee else 0 end) ljfee,-- 累计费用	
		SUM(yjbg) prebg, -- 预计总报工
		sum(case WHEN nowyear < t.query_year then sjbg else 0 end) wnbg,-- 往年实际报工
		sum(case when nowyear = t.query_year then sjbg else 0 end) dnbg,-- 当年实际报工
		sum(case when nowyear <= t.query_year then sjbg else 0 end) ljbg,-- 累计报工	
		SUM(income) preincome, -- 项目预计总收入
		SUM(realcost) ljcost-- 项目累计成本汇总
	FROM
	(
		SELECT
			projectid,	yjbg,	sjbg,	fee,	realfee,	yjcb_cg,	purchasecost,	realcost,	income,	nowyear
		FROM t_report_projectinfoinout
		GROUP BY projectid, nowyear
	) fi,
	(SELECT DATE_FORMAT(NOW(),'%Y') query_year from DUAL) t
	GROUP BY projectid
) x4 on x.projectid = x4.projectid

LEFT JOIN
(
	SELECT
		projectid,
		SUM(sumcost) prerl, -- 预计总人力成本
		sum(case WHEN left(yearmonth, 4) < t.query_year then sumcost else 0 end) wnrl,-- 往年实际人力成本
		sum(case when left(yearmonth, 4) = t.query_year and yearmonth < DATE_FORMAT(CURRENT_DATE,'%Y%m') then sumcost else 0 end) dnrl,-- 当年实际人力成本
		sum(case when yearmonth <= DATE_FORMAT(CURRENT_DATE,'%Y%m') then sumcost else 0 end) ljrl-- 累计人力成本汇总
-- 		left(yearmonth, 4) year4
	FROM
	(
		SELECT  
			projectid,
			sumcost,
			sumworkload,
			sumfigure,
			yearmonth
		FROM `t_project_monthbudget`
	) fi,
		(SELECT DATE_FORMAT(NOW(),'%Y') query_year from DUAL) t
	GROUP BY projectid
) x5 on x.projectid = X5.projectid

WHERE 1=1
-- and dnrl <> 0 and dnbg = 0
-- {projecttype}
-- {projstatus}
GROUP BY x.projectno, x.nowyear
order by x.pm
