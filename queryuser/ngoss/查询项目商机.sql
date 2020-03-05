SELECT
*,
translatedict('IDFS000052', oppstep) oppstepname-- 商机阶段
FROM (
	select
			oppid,
			oppmainno,-- '主商机编号',
			businessid bobusinessid,-- 客户商机ID',
			case when oppstep = '4' and oppid in (select a.projectbusinessid from t_project_projectinfo_tmp a where a.approvestatus not in ( '3' )and a.opertype = '1') then '5' else oppstep end as oppstep,
			-- oppno,-- 商机编号
			oppname,-- 商机名称
			year boyear,-- 所属年份
			signposibility,-- 签约可能性
			createdate,-- 创建日期
			predictstartdate, -- beiyong,
			predicttotalprice,-- 预计项目总价
			getusername(applyuser) beiyong,-- 申请人，项目负责人
			getunitname(deptid) beiyong2,-- 申请人，项目负责人
			translatedict('IDFS000068', opertype) opertypename,-- '操作类型(1-新增，2-变更)',
			translatedict('IDFS000078', status) bostatus, -- 项目商机状态(1-未生效，2-已生效，3-变更中',
			getusername(saleid) salename,-- 销售代表',
			(select SUBSTRING_INDEX(SUBSTRING_INDEX(remark4,'-',2),'-',-1) from t_sys_mngunitinfo where unitid = (select deptid from t_sys_mnguserinfo where userid = saleid)) salearea,
			saleid,
			prjapplyfigure,-- 项目阶段预算
			oppapplyfigure-- 项目商机阶段预算
	from t_sale_businessopportunity
) bo
left join
		(SELECT businessid cbbusinessid,-- 客户商机ID
						businessno,-- 客户商机编号
						custid cbcustid,-- 客户ID
						businessname,-- 客户商机名称
						predictsumprice applyfigure,-- 客户商机金额
						year cbyear,-- 所属年度
						translatedict('IDFS000079', status) cbstatus,--  '状态(1-未生效，2-已生效，3-变更中)',IDFS000065
						remark,
						getcustname(custid) custname,-- 客户名称
						-- applyfigure,-- 客户商机申请金额
						createdate cbcreatedate,-- 创建时间
						getusername(applyuserid) cbapplyusername
		from t_sale_customerbusiness) cb ON cb.cbbusinessid = bo.bobusinessid

left join 
		(select projectid, projectno, projectbusinessid, 
						projectname,-- 项目名称
						budgetcontractamout predictfigure,--  预计金额
						getusername(pm) prjpmname, 
						getusername(pd) prjpdname, 
						getunitname(deptid) sub,
						predictstartdate prjpredictstartdate,-- 预计开始日期
						createtime prjcreatetime-- 项目开始时间
		from t_project_projectinfo) prj ON prj.projectbusinessid = bo.oppid
LEFT JOIN 
		(select custid ccustid, tecpersonid,
						getusername(tecpersonid) tecperson,
						getunitname((SELECT deptid from t_sys_mnguserinfo WHERE userid = tecpersonid) ) tecpersonunit
		from t_sale_custbasicdata) cust on cust.ccustid = cb.cbcustid
left join (
		SELECT 
			oppid preoppid, preincome1, preincome2, preincome3, preincome4, preincome5, preincome6,
			preincome7, preincome8, preincome9, preincome10, preincome11, preincome12
		FROM `query`.view_prebusinessincome
) pre on pre.preoppid = bo.oppid
LEFT JOIN
		(select presaleid, presaleno, presalename, projbusinessid
		from t_sale_presales
		) presale on presale.projbusinessid = bo.oppid 
WHERE 1=1
-- AND :currentuser in (saleid, tecpersonid)
-- {oppmainno}
-- {projectno}
-- {prjpmname}
-- {prjpdname}
-- {businessno}
-- {cbyear}
-- {salename}
-- {tecperson}
and (SUBSTRING_INDEX(projectno,'-',1) != 'zl' or projectno is null)
ORDER BY bo.oppmainno