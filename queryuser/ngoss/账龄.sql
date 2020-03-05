-- 查询日期
set @searchtime := 20180515;
SELECT
	p.*,
	`m1`,`m2`,`m3`,`m4`,`m5`,`m6`,`m7`, prjincome, prjsbillamt, diss

FROM
	(
		SELECT 
			projectid, projectno, projectname, -- 项目id 编号 名称
			ngoss.translatedict(projecttype,-- 项目类型,
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
			budgetcontractamout-- 立项金额
		from  t_project_projectinfo p
		join t_sale_custbasicdata cust on p.finalcustomer = cust.custid
		where p.projecttype  not in (5,8) 
-- 		{projectno} {projectname}
	) p
join (
		SELECT
			x.projectid, projectno, projectname, prjincome, IFNULL(prjsbillamt,0) prjsbillamt, diss,
			sum(case when yearmonth = DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 1 MONTH), '%Y%m') then wpys else 0 end) 'm1',
			sum(case when yearmonth = DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 2 MONTH), '%Y%m') then wpys else 0 end) 'm2',
			sum(case when yearmonth = DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 3 MONTH), '%Y%m') then wpys else 0 end) 'm3',
			sum(case when yearmonth BETWEEN DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 6 MONTH), '%Y%m') and DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 4 MONTH), '%Y%m') then wpys else 0 end) 'm4',
			sum(case when yearmonth BETWEEN DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 12 MONTH), '%Y%m') and DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 7 MONTH), '%Y%m') then wpys else 0 end) 'm5',
			sum(case when yearmonth BETWEEN DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 24 MONTH), '%Y%m') and DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 13 MONTH), '%Y%m') then wpys else 0 end) 'm6',
			sum(case when yearmonth < DATE_FORMAT(SUBDATE(@searchtime,INTERVAL 24 MONTH), '%Y%m') then wpys else 0 end) 'm7'
		from
		(
				SELECT
					a.*,ifnull(f_sbillamt,0) f_sbillamt,
				case 
					when sumincome > ifnull(f_sbillamt,0) and sumincomeb >= ifnull(f_sbillamt,0) then income
					when sumincome > ifnull(f_sbillamt,0) and sumincomeb < ifnull(f_sbillamt,0) then sumincome - ifnull(f_sbillamt,0)
					when sumincome <= ifnull(f_sbillamt,0) then 0 end as wpys
				from
				(
							SELECT
								a.projectid, projectno, projectname, yearmonth, income, 
								(sumincome+IFNULL(c.diss,0)) sumincome, (IFNULL(sumincomeb,0)+IFNULL(c.diss,0)) sumincomeb
							from  `query`.t_zhangling a
							left join	(
									SELECT
										projectid,  diss
									FROM `t_income_initincome2`
							) c on a.projectid = c.projectid
							union all
							SELECT
								projectid, projectno, projectname,'201612' as yearmonth, diss, diss, 0
							FROM `t_income_initincome2`
							where projectid is not null
							GROUP BY projectid
				)a
				left join (
						SELECT 
								projectid,
								SUM(f_sbillamt) f_sbillamt
						from t_contract_stage_ysf_tian
						WHERE left(f_sbillfpdate,6)> 201612 and left(f_sbillfpdate,6)<= @searchtime
						GROUP BY projectid
				) b on a.projectid = b.projectid
		)x
	left join (SELECT projectid, SUM(IFNULL(f_sbillamt,0)) prjsbillamt from t_contract_stage_ysf_tian GROUP BY projectid) x1 on x.projectid = x1.projectid
	left join (select projectid, SUM(curmonincome+adjustincome-taxfreeincome+curmontax) prjincome from t_income_prjmonthincome_fi GROUP BY projectid) x2 on x.projectid = x2.projectid
	left join (SELECT projectid, diss FROM `t_income_initincome2` where projectid is not null) x3 on x.projectid = x3.projectid
	GROUP BY x.projectid 
) zl on zl.projectid = p.projectid

;