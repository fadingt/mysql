set @year := 2018;
SELECT 
	wnhk, dnhk, prj_ybillamt, prj_fsreceamt, prj_dn_fsreceamt,
	a.projectid,a.projectno,a.projectname,a.projecttype,a.sale, a.salearea,
	a.pmname, a.pdname, a.signcompany, a.signcust, a.finalcust, a.tecperson, a.tecpersonunit,
	a.predictstartdate,	a.predictenddate,	a.maintenancedate,
	a.contracttime,a.contractstatus,
	IFNULL(a.budgetcontractamout,0) budgetcontractamout,
	IFNULL( a.yqrsr,0)yqrsr, IFNULL(a.wqrsr,0)wqrsr,
	wnqrsr, dnqrsr,
	a.chazhi, a.chazhi2, 
	IFNULL(yearprojectfigure,0)yearprojectfigure,-- 当年立项金额
	isprojstatus, -- 是否结项
	b.zbtzs, b.rctzs, b.jfyj, case when b.tradeid is null then 0 else 1 end srzm
FROM
(
	SELECT 
		p.*, -- 项目基本信息 有权限
		DATE_FORMAT(s.contracttime, '%Y-%m-%d')contracttime,  -- 预计合同签约日期
		case when p.projectid in (select projectid from t_contract_projectrelation ) then '是'  else '否' end contractstatus,-- 是否已转合同
		case when p.projectid in (select projectid from t_contract_projectrelation ) then null else TO_DAYS(DATE_FORMAT(s.contracttime,'%Y-%m-%d'))-TO_DAYS(date_format(now(),'%Y-%m-%d')) end chazhi,-- 签约预警（距当前日期） 
		TO_DAYS(DATE_FORMAT(p.predictstartdate,'%Y-%m-%d'))-TO_DAYS(date_format(current_timestamp(),'%Y-%m-%d'))  chazhi2,-- 签约预警（距项目开始日期）

		IFNULL(d1.ybillamt,0) prj_ybillamt,-- 已转合同金额
		IFNULL(d2.prj_fsreceamt,0) prj_fsreceamt,-- 已分配合同金额
		IFNULL(d2.prj_dn_fsreceamt,0) prj_dn_fsreceamt,-- 当年已分配合同金额
		IFNULL(d.dnhk,0) dnhk,-- 当年回款
		IFNULL(d.wnhk,0) wnhk,
		fi.yqrsr, fi.dnqrsr, fi.wnqrsr, (p.budgetcontractamout - yqrsr ) wqrsr -- 未确认收入
	FROM
	(
		SELECT 
			projectid, projectno, projectname, -- 项目id 编号 名称
			projecttype,-- 项目类型,
			getusername(saleid) as sale,-- 销售代表
			(SELECT getunitname(parentunitid) from t_sys_mngunitinfo WHERE unitid = (SELECT deptid from t_sys_mnguserinfo WHERE userid = saleid)) salearea, -- 销售代表所属销售大区
			getusername(pm) as pmname, getusername(pd)pdname,-- 项目经理 总监
			getusername(cust.tecpersonid) tecperson, (SELECT remark4 from t_sys_mngunitinfo WHERE unitid = (select deptid from t_sys_mnguserinfo WHERE userid = cust.tecpersonid)) tecpersonunit,-- 客户经理 客户经理部门
			getunitname(gatheringunitid)signcompany,-- 签约公司
			getcustname(signedcustomer)signcust,-- 签约客户
			getcustname(finalcustomer)finalcust,-- 最终客户
			DATE_FORMAT(predictstartdate, '%Y-%m-%d') predictstartdate,-- 预计项目开始时间
			DATE_FORMAT(predictenddate, '%Y-%m-%d') predictenddate,-- 预计项目结束时间
			DATE_FORMAT(maintenancedate, '%Y-%m-%d') maintenancedate,-- 维护期结束时间
			case when projstatus= '9' then '项目已取消'  when projstatus= '7'  then '项目暂停' when projstatus= '6' then '是' else '否' end isprojstatus, -- 是否结项
			budgetcontractamout,-- 立项金额
			case when  SUBSTR(p.createtime FROM 1 FOR 4)=DATE_FORMAT(current_timestamp(),'%Y' ) then budgetcontractamout else 0 END yearprojectfigure -- 当年立项金额
		from  t_project_projectinfo p
		join t_sale_custbasicdata cust on p.finalcustomer = cust.custid
		where 
			p.projecttype  not in (5,8) 
-- 			and  (:currentuser in (pd, pm, tecpersonid, saleid) or deptid in (:roledatascope) )
-- 			{projectno} {projectname}
	) p

	LEFT JOIN t_project_gatheringpredict s -- 收款预测表
	ON p.projectid=s.projectid 

	LEFT JOIN (
		select
				projectid,
				SUM( fi.monthincome) yqrsr,-- 累计收入
				SUM(case when  @year = left(fi.yearmonth,4) then fi.monthincome else 0 END ) dnqrsr,-- 当年收入
				SUM(case when  @year > left(fi.yearmonth,4) then fi.monthincome else 0 END ) wnqrsr-- 往年收入
		FROM
		(
				SELECT 
					projectid, (curmonincome+adjustincome+taxfreeincome) monthincome, yearmonth 
				from t_income_prjmonthincome_fi
		) fi
		GROUP BY projectid
	) fi ON fi.projectid=p.projectid

	left join(-- 实际回款
		SELECT
			d.projectid,
			SUM(case when d.year = @year then sreceamt else 0 end) dnhk,-- 当年回款
			SUM(case when d.year < @year then sreceamt else 0 end) wnhk
		from(
			select
				projectid, SUM(sreceamt) sreceamt, left(srecedate, 4) `year`
			from t_project_stage_ys_tian
			where srecedate is not null
			group by projectid, left(srecedate, 4)
		)d
		GROUP BY d.projectid
	) d on d.projectid = p.projectid
	left join(-- 预计开票 已转合同金额
			select
				projectid,SUM(ybillamt) ybillamt
			from t_project_stage_ys_tian
			group by projectid
	) d1 on d1.projectid = p.projectid
	left join(-- 预计回款 已分配金额
		SELECT
			d2.projectid,
			SUM(d2.yreceamt) prj_fsreceamt,-- 已分配合同金额
			SUM(case when d2.year = @year then d2.yreceamt else 0 end) prj_dn_fsreceamt-- 当年已分配合同金额
		FROM(
			select
				projectid, SUM(yreceamt) yreceamt, left(yrecedate, 4) `year`
			from t_project_stage_ys_tian
			where srecedate is not null
			group by projectid, left(yrecedate, 4)
		)d2
		GROUP BY d2.projectid
	) d2 on d2.projectid = p.projectid

) a
left join(
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
-- 	{srzm} 
ORDER BY sale
;
