/*
项目YY当年收入实开实回
表结构：
	xxx
		y
			x
				t
				xx
				a
				b
				c
				d
		y0
		y1
		y2
*/
select                                      
	projectid, projectno, projectname,
	pmname, pdname, salename, saledept, finalcusname, projectdeptname,
	dictcname, dictname,
	projecttype, businesstype, projstatus,
	predictstartdate,predictenddate,maintenancedate,
	htfpe,
	budgetcontractamout, -- 含税预算合同总额
	realincom, billall, receall,
	sr1,yk1,yh1,sk1,sh1,
	sr2,yk2,yh2,sk2,sh2,
	sr3,yk3,yh3,sk3,sh3,
	sr4,yk4,yh4,sk4,sh4,
	sr5,yk5,yh5,sk5,sh5,
	sr6,yk6,yh6,sk6,sh6,
	sr7,yk7,yh7,sk7,sh7,
	sr8,yk8,yh8,sk8,sh8,
	sr9,yk9,yh9,sk9,sh9,
	sr10,yk10,yh10,sk10,sh10,
	sr11,yk11,yh11,sk11,sh11,
	sr12,yk12,yh12,sk12,sh12
from
(
	select 
		y.*,
		y1.projstatus,
		ifnull(y.billamt,0)+ifnull(bill2015,0) as billall,
		ifnull(y.receamt,0)+ifnull(rece2015,0) as receall,
		-- 1-12月预计开票
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'01') then ifnull(ybillamt,0) else 0 end) yk1,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'02') then ifnull(ybillamt,0) else 0 end) yk2,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'03') then ifnull(ybillamt,0) else 0 end) yk3,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'04') then ifnull(ybillamt,0) else 0 end) yk4,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'05') then ifnull(ybillamt,0) else 0 end) yk5,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'06') then ifnull(ybillamt,0) else 0 end) yk6,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'07') then ifnull(ybillamt,0) else 0 end) yk7,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'08') then ifnull(ybillamt,0) else 0 end) yk8,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'09') then ifnull(ybillamt,0) else 0 end) yk9,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'10') then ifnull(ybillamt,0) else 0 end) yk10,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'11') then ifnull(ybillamt,0) else 0 end) yk11,
		sum(case when left(ybilldate,6)=CONCAT(left(:showtime,4),'12') then ifnull(ybillamt,0) else 0 end) yk12,
		-- 1-12月预计回款
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'01') then ifnull(yreceamt,0) else 0 end) yh1,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'02') then ifnull(yreceamt,0) else 0 end) yh2,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'03') then ifnull(yreceamt,0) else 0 end) yh3,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'04') then ifnull(yreceamt,0) else 0 end) yh4,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'05') then ifnull(yreceamt,0) else 0 end) yh5,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'06') then ifnull(yreceamt,0) else 0 end) yh6,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'07') then ifnull(yreceamt,0) else 0 end) yh7,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'08') then ifnull(yreceamt,0) else 0 end) yh8,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'09') then ifnull(yreceamt,0) else 0 end) yh9,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'10') then ifnull(yreceamt,0) else 0 end) yh10,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'11') then ifnull(yreceamt,0) else 0 end) yh11,
		sum(case when left(yrecedate,6)=CONCAT(left(:showtime,4),'12') then ifnull(yreceamt,0) else 0 end) yh12,
		-- 1-12月实际开票
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'01') then ifnull(sbillamt,0) else 0 end) sk1,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'02') then ifnull(sbillamt,0) else 0 end) sk2,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'03') then ifnull(sbillamt,0) else 0 end) sk3,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'04') then ifnull(sbillamt,0) else 0 end) sk4,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'05') then ifnull(sbillamt,0) else 0 end) sk5,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'06') then ifnull(sbillamt,0) else 0 end) sk6,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'07') then ifnull(sbillamt,0) else 0 end) sk7,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'08') then ifnull(sbillamt,0) else 0 end) sk8,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'09') then ifnull(sbillamt,0) else 0 end) sk9,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'10') then ifnull(sbillamt,0) else 0 end) sk10,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'11') then ifnull(sbillamt,0) else 0 end) sk11,
		sum(case when left(sbilldate,6)=CONCAT(left(:showtime,4),'12') then ifnull(sbillamt,0) else 0 end) sk12,
		-- 1-12月实际回款
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'01') then ifnull(y2.sreceamt,0) else 0 end) sh1,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'02') then ifnull(y2.sreceamt,0) else 0 end) sh2,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'03') then ifnull(y2.sreceamt,0) else 0 end) sh3,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'04') then ifnull(y2.sreceamt,0) else 0 end) sh4,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'05') then ifnull(y2.sreceamt,0) else 0 end) sh5,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'06') then ifnull(y2.sreceamt,0) else 0 end) sh6,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'07') then ifnull(y2.sreceamt,0) else 0 end) sh7,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'08') then ifnull(y2.sreceamt,0) else 0 end) sh8,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'09') then ifnull(y2.sreceamt,0) else 0 end) sh9,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'10') then ifnull(y2.sreceamt,0) else 0 end) sh10,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'11') then ifnull(y2.sreceamt,0) else 0 end) sh11,
		sum(case when left(srecedate,6)=CONCAT(left(:showtime,4),'12') then ifnull(y2.sreceamt,0) else 0 end) sh12,
		-- 1-12月收入
		sr1,sr2,sr3,sr4,sr5,sr6,sr7,sr8,sr9,sr10,sr11,sr12

	from (
		select
				x.dictcname, x.dictname, x.projecttype, x.businesstype, x.saledept, x.projectid, x.projectno, x.projectname,
				x.pmname, x.pdname, x.salename, x.maintenancedate, finalcusname, projectdeptname, x.predictstartdate,x.predictenddate,
				budgetcontractamout,predictcost, sum(realincom) realincom, sum(sbillamt) billamt, sum(sreceamt) receamt,
				sum(ybillamt) as htfpe -- 合同分配金额
		from
		(
				select
						xx.dictcname,xx.dictname,nowyear,
						translatedict('IDFS000091',t.projecttype) projecttype,
						translatedict('IDFS000092',t.businesstype) businesstype,
						t.projectid,t.projectno,t.projectname,t.projstatus,t.maintenancedate,pmname,pdname,salename,
						getcustname(finalcustomer) finalcusname,t.predictstartdate,t.predictenddate,
						(select remark4 from  t_sys_mngunitinfo n where t.deptid=n.unitid) as projectdeptname,predictcost,
						(select remark4 from  t_sys_mngunitinfo n where n.unitid=( select deptid from t_sys_mnguserinfo where userid=t.saleid) ) saledept,
						budgetcontractamout,a.realincom,sbillamt,sreceamt,ybillamt
				from t_report_projectinfoinout t  
				left join 
				(
						select t.dictitem,t.dictcname,t1.dictname,t1.dictvalue,t.datalen,t.secondaryvalue
						from (select * from t_sys_dicttype  ) t
						join t_sys_dictvalue t1 on t.dictitem=t1.dictitem 
				)xx on t.technologyarea=xx.secondaryvalue and xx.dictvalue=t.technologyarea2  
				left join 
				(
						select sum(originaincome1) realincom ,projectid,left(month,4) year 
						from t_income_projectincome GROUP BY projectid,left(month,4)
				)a on a.projectid=t.projectid and a.year=t.nowyear
				left join 
				(
						select projectid,left(sbilldate,4) year,ifnull(sum(sbillamt),0) sbillamt 
						from t_project_stage_ys_tian
						GROUP BY projectid,left(sbilldate,4)
				)b on b.projectid=t.projectid and b.year=t.nowyear
				left join 
				(
						select projectid,left(srecedate,4) year,ifnull(sum(sreceamt),0) sreceamt 
						from t_project_stage_ys_tian 
						GROUP BY projectid,left(srecedate,4)
				)c on c.projectid=t.projectid and c.year=t.nowyear
				left join 
				(
						select projectid,left(ybilldate,4) year,ifnull(sum(ybillamt),0) ybillamt 
						from t_project_stage_ys_tian 
						GROUP BY projectid,left(ybilldate,4)
				)d on d.projectid=t.projectid and d.year=t.nowyear
		) x where projectno like '%yy%' GROUP BY projectid
	) y
	left join 
	(
		select proj_id,bill_amt_sum bill2015,rece_amt_sum rece2015 
		from t_project_month_income -- 2015 收入  开票 回款
	) y0 on y0.proj_id=y.projectid
/*
	left join (
	select projectid,sum(originaincome1) originaincome1,month from t_income_projectincome  t GROUP  BY projectid,left(month,6)
	)y1 on y.projectid=y1.projectid
*/
	left join (
			select projectid,translatedict ('IDFS000070', projstatus) projstatus,jan_sjsr sr1 ,feb_sjsr sr2,mar_sjsr sr3,apr_sjsr sr4,may_sjsr sr5,jun_sjsr sr6,jul_sjsr sr7,aug_sjsr sr8,sep_sjsr sr9,oct_sjsr sr10,nov_sjsr sr11,feb_sjcb  sr12 
			from t_report_projectinfoinout 
			where nowyear=left(:showtime,4)
	) y1 on y1.projectid=y.projectid
	left join (
			select projectid, left(srecedate,4) year, ybilldate, yrecedate, sbilldate, srecedate, ifnull(ybillamt,0) ybillamt, ifnull(yreceamt,0) yreceamt, ifnull(sbillamt,0) sbillamt, ifnull(sreceamt,0) sreceamt 
			from t_project_stage_ys_tian  
	) y2 on y.projectid=y2.projectid

	GROUP BY projectid ORDER BY projectid



)xxx


where 1=1
{projectno}
{projectname}
