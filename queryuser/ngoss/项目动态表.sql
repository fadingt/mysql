set @year := 2018;
-- @year @year
SELECT 
	getProjAccountPeriod(a.projectid)accountPeriod,
	ifnull((select tt.receamt 
					from  (select projectid,sum(a.p_yreceamt) as receamt  
								 from view_project_srece_tian a 
								 where substr(msrecedate,1,4) =  @year
								 GROUP BY a.projectid) tt 
					where tt.projectid = a.projectid) ,0)as dnhk,                            
	ifnull(wnhk,0) as wnhk,a.projectid,a.projectno,a.projectname,a.projecttype,a.sale, a.salearea,
	a.pmname,
	a.pdname,
	a.signcompany,
	a.signcust,
	a.finalcust,
	a.predictstartdate,
	a.predictenddate,
	a.maintenancedate,
	a.contracttime,a.contractstatus,
	IFNULL(a.budgetcontractamout,0) budgetcontractamout,
	IFNULL( a.yqrsr,0)yqrsr,
	wnqrsr,
	dnqrsr,
	IFNULL(a.wqrsr,0)wqrsr,
	a.chazhi,
  a.chazhi2, 
	IFNULL(a.contractprice,0)contractprice,IFNULL(yearprojectfigure,0)yearprojectfigure,-- 当年立项金额
	IFNULL(yearcontractfigure,0)yearcontractfigure,-- 当年合同金额
	projectsumworkload, -- 报工人/天
	-- prj_f_sreceamt,
	isprojstatus, -- 是否结项
	b.zbtzs, b.rctzs, b.jfyj, case when b.tradeid is null then 0 else 1 end srzm
FROM
(
	SELECT 
		p.projectid,
		p.projectno, -- 项目编号
		p.projectname, -- 项目名称
		p.projecttype,-- 项目类型,
		getusername(p.saleid) as sale,-- 销售代表
		(SELECT getunitname(parentunitid) from t_sys_mngunitinfo WHERE unitid = (SELECT deptid from t_sys_mnguserinfo WHERE userid = p.saleid)) salearea, -- 销售代表所属销售大区
		getusername(p.pm) as pmname,-- 项目经理
		getusername(p.pd)pdname,-- 项目总监
		getunitname(p.gatheringunitid)signcompany,-- 签约公司
		getcustname(p.signedcustomer)signcust,-- 签约客户
		getcustname(p.finalcustomer)finalcust,-- 最终客户
		CASE
		WHEN p.predictstartdate IS NULL
		OR p.predictstartdate = '' THEN
			''
		ELSE
			DATE_FORMAT(
				STR_TO_DATE(p.predictstartdate, '%Y%m%d'),
				'%Y-%m-%d'
			)
		END AS predictstartdate,-- 预计项目开始时间

		CASE
		WHEN p.predictenddate IS NULL
		OR p.predictenddate = '' THEN
			''
		ELSE
			DATE_FORMAT(
				STR_TO_DATE(p.predictenddate, '%Y%m%d'),
				'%Y-%m-%d'
			)
		END AS predictenddate,-- 预计项目结束时间

		CASE
		WHEN p.maintenancedate IS NULL
		OR p.maintenancedate = '' THEN
			''
		ELSE
			DATE_FORMAT(
				STR_TO_DATE(p.maintenancedate, '%Y%m%d'),
				'%Y-%m-%d'
			)
		END AS maintenancedate,-- 维护期结束时间
		CASE
		WHEN s.contracttime  IS NULL
		OR s.contracttime  = '' THEN
			''
		ELSE
			DATE_FORMAT(
				STR_TO_DATE(s.contracttime , '%Y%m%d'),
				'%Y-%m-%d'
			)
		END AS contracttime,  -- 预计合同签约日期


		case when p.projectid in (select projectid from t_contract_projectrelation ) then '是'
		else '否' end contractstatus,-- 是否已转合同


		case when p.projectid in (select projectid from t_contract_projectrelation ) then null
		else TO_DAYS(DATE_FORMAT(s.contracttime,'%Y-%m-%d'))-TO_DAYS(date_format(now(),'%Y-%m-%d')) end chazhi,-- 签约预警（距当前日期） 
		TO_DAYS(DATE_FORMAT(p.predictstartdate,'%Y-%m-%d'))-TO_DAYS(date_format(current_timestamp(),'%Y-%m-%d'))  chazhi2,-- 签约预警（距项目开始日期）

		case 
                when p.projstatus= '9' then '项目已取消'
                when p.projstatus= '6' then '是' else '否' end isprojstatus,
		-- 是否结项
		p.budgetcontractamout,-- 立项金额
		case when  SUBSTR(p.createtime FROM 1 FOR 4)=DATE_FORMAT(current_timestamp(),'%Y' ) then p.budgetcontractamout else 0 END yearprojectfigure, 
		-- 当年立项金额
		case
		when p.projecttype in (4,7,2,6) 
		then  (SELECT sum(amt) FROM t_contract_project_stage WHERE projectid=p.projectid)
		when  p.projectid not in (SELECT projectid FROM t_contract_projectrelation)  
		then  0
		else 0 
		end  contractprice, -- 合同金额（固定金额都取的合同金额）
		/* case 
		when p.projecttype in (4,7) 
		then  (SELECT sum(paymented) FROM t_contract_project_stage WHERE projectid=p.projectid) 
		when  p.projecttype in (2,6)
		then (SELECT sum(m.contractprice) FROM t_contract_projectrelation c,t_contract_main m WHERE c.contractid=m.contractid and c.projectid=p.projectid and SUBSTR(begintime FROM 1 FOR 4)=DATE_FORMAT(current_timestamp(),'%Y' ) and m.effectstatus not in (7,8))
		else 0 
		end yearcontractfigure,-- 当年合同金额 */

    case 
		when p.projecttype in (4,7,2,6) 
		then  
		(
			SELECT
				sum(f_yreceamt)
			FROM
			(
				SELECT contractid, f_yreceamt,  projectid
				FROM t_contract_stage_ysf_tian
			) t1
			LEFT JOIN 
			(
				SELECT
					contractid,
					LEFT (begintime, 4) c_year
				FROM
					t_contract_main
			) t2 ON t1.contractid = t2.contractid
			WHERE
				c_year =@year and t1.projectid = p.projectid
		)
		else 0 
		end yearcontractfigure,-- 当年合同金额

		-- prj_f_sreceamt,
/*
		sum(case when pp.month < (select CONCAT(( @year-1),'12') from dual)  then pp.originaincome1 else 0 end ) wnqrsr,  
		sum(case when substr(pp.month,1,4) =  @year then pp.originaincome1 else 0 end) dnqrsr, 
		sum(case when substr(pp.month,1,4) <= @yearthen pp.originaincome1 else 0 end) yqrsr,-- 已确认收入
		-- p.budgetcontractamout-sum(pp.originaincome1) wqrsr, -- 未确认收入
		p.budgetcontractamout-sum(case when substr(pp.month,1,4) <= @year then pp.originaincome1 else 0 end) wqrsr,
*/
		SUM( fi.monthincome) yqrsr,-- 累计收入
		SUM(case when  @year = left(fi.yearmonth,4) then fi.monthincome else 0 END ) dnqrsr,-- 当年收入
		SUM(case when  @year > left(fi.yearmonth,4) then fi.monthincome else 0 END ) wnqrsr,-- 往年收入
		(p.budgetcontractamout - SUM(fi.monthincome) ) wqrsr, -- 未确认收入

		i.rece_amt_sum wnhk                                                           
	FROM t_project_projectinfo p
	LEFT JOIN (select  aa1.proj_id ,(aa1.rece_amt_sum+ifnull(aa2.receamt,0))as rece_amt_sum
						from 
						(SELECT proj_id,sum(rece_amt_sum) as rece_amt_sum
												 FROM t_project_month_income 
												 WHERE  income_month <=(select CONCAT(( @year-1),'12') from dual) 
												 GROUP BY proj_id)aa1
						LEFT JOIN
						(select projectid,sum(a.p_yreceamt) as receamt  
														 from view_project_srece_tian a 
														 where substr(msrecedate,1,4) <  @year
														 GROUP BY a.projectid)aa2
						on aa1.proj_id = aa2.projectid) i 
	ON i.proj_id=p.projectid
	LEFT JOIN
		t_project_gatheringpredict s -- 收款预测表
	ON p.projectid=s.projectid 
	-- LEFT JOIN t_report_projectinfoinout t
	-- ON t.projectid=p.projectid
-- 	LEFT JOIN t_income_projectincome  pp
-- 	ON pp.projectid=p.projectid
	LEFT JOIN (SELECT projectid, (curmonincome+adjustincome+taxfreeincome) monthincome, yearmonth from t_income_prjmonthincome_fi) fi  
	ON fi.projectid=p.projectid
	-- left join (SELECT projectid, SUM(f_sreceamt) prj_f_sreceamt from t_contract_stage_ysf_tian GROUP BY projectid) ysf
	-- on ysf.projectid = p.projectid
	where p.projecttype  not in (5,8)     --   and  t.projecttype  not in (5,8) 
	GROUP BY p.projectid) a
LEFT JOIN (
		SELECT targetid, SUM(workhours/8) projectsumworkload
		from t_report_workhourdetail
		WHERE workhourtype = 0 and year <= DATE_FORMAT(current_timestamp(),'%Y' )
		GROUP BY targetid
) m
ON m.targetid=a.projectid
left join 
(
SELECT 
		tradeid,tradecode,
		max(case when tradecode = 't_project_projectinfo_addition_zb' and infoex = '1' then substring_index(substring_index(concat('\\',attachmentname) ,'\\',-1),'：',1) end) zbtzs,
		max(case when tradecode = 't_project_projectinfo_addition_rc' and infoex = '2' then substring_index(substring_index(concat('\\',attachmentname) ,'\\',-1),'：',1) end) rctzs,
		max(case when tradecode = 't_project_projectinfo_addition_em' and infoex = '3' then substring_index(substring_index(concat('\\',attachmentname) ,'\\',-1),'：',1) end) jfyj
from t_public_attachment 
WHERE infoex in (1,2,3)
GROUP BY tradeid
)b on a.projectid = b.tradeid

where
1=1
--  {projectno}
--   {projectname}
-- {srzm}
-- 
ORDER BY sale
;