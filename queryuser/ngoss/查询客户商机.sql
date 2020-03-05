/*
查询客户商机 customerbusiness_all

使用人：
项目服务部QA 全量查询				业务合规部 全量查询
*/

SELECT *
FROM
(
		SELECT
			cbbusinessid, tecpersonid, saleid,
			businessno,  businessname, -- 客户商机编号 名称
			custname, -- 客户名称
			cbyear, -- 商机年度
			cbapplyusername  salename, getusername(tecpersonid) tecperson,-- 销售代表 技术负责人
			salearea, tecpersonunit,-- 销售大区 技术负责人部门
			cbcreatedate,-- 创建时间
			predictsumprice,-- 预计总价-- 客户商机金额
			(CASE WHEN oppid is not null THEN COUNT(bobusinessid) ELSE 0 END) oppcnt, -- 已转商机数
			SUM(predicttotalprice) sumboprice,-- 已转项目商机金额
			SUM(predicttotalprice) / predictsumprice bopercb, -- 转项目商机金额占比
			(CASE WHEN projectid is not null THEN COUNT(projectid) ELSE 0 END) projcnt,-- 已立项数
			SUM(prj.predictfigure) sumpprice

		FROM (
			select 
					businessid cbbusinessid, businessno, businessname,-- 客户商机ID 编号 名称
					custid cbcustid,-- 客户ID
					predictsumprice,-- 预计总价
					year cbyear,-- 商机年度
					status cbstatus,--  '状态(1-未生效，2-已生效，3-变更中)',IDFS000079
					getcustname(custid) custname,-- 客户名称
					applyfigure,-- 客户商机金额
					createdate cbcreatedate,-- 创建时间
					getusername(applyuserid) cbapplyusername,
					(select SUBSTRING_INDEX(SUBSTRING_INDEX(remark4,'-',2),'-',-1) from t_sys_mngunitinfo where unitid = (select deptid from t_sys_mnguserinfo where userid = applyuserid)) salearea
			from t_sale_customerbusiness
			where `status` = 2
		) cb

		left join (
			select 
					oppid,
					oppmainno,-- '主商机编号',
					businessid bobusinessid,-- 客户商机ID',
					oppname,-- 商机名称
					-- year boyear,-- 所属年份
					signposibility,-- 签约可能性
					createdate,-- 创建日期
					predicttotalprice,-- 预计项目总价
					getusername(applyuser) applyusername,-- 申请人,项目负责人
					-- translatedict('IDFS000068', opertype) opertypename,-- '操作类型(1-新增，2-变更)',
					infoex2, infoex3,-- 项目经理 项目总监
					translatedict('IDFS000078', status) bostatus, -- 项目商机状态(1-未生效，2-已生效，3-变更中',
					saleid,
					prjapplyfigure,-- 项目阶段预算
					oppapplyfigure-- 项目商机阶段预算
			from t_sale_businessopportunity
			WHERE `status` != 4
		) bo ON cb.cbbusinessid = bo.bobusinessid

		left join (
			select 
					projectid, projectno, projectbusinessid, projectname,-- 项目id 编号 名称
					budgetcontractamout predictfigure,--  立项金额
					getusername(pm) prjpmname, getusername(pd) prjpdname, 
					getunitname(deptid) sub,
					predictstartdate prjpredictstartdate,-- 预计开始日期
					createtime prjcreatetime-- 项目开始时间
			from t_project_projectinfo
		) prj ON prj.projectbusinessid = bo.oppid
		LEFT JOIN (
			select custid ccustid, tecpersonid, getunitname((SELECT deptid from t_sys_mnguserinfo WHERE userid = tecpersonid) ) tecpersonunit
			from t_sale_custbasicdata
		) cust on cust.ccustid = cb.cbcustid
		GROUP BY cbbusinessid
)t

WHERE 1=1 
AND :currentuser in (saleid, tecpersonid)
-- {businessno}
-- {cbyear}
-- {tecperson}
-- {salename}
-- {bopercb}
-- {bopercbmin}
-- {bopercbmax}
GROUP BY cbbusinessid
ORDER BY cbbusinessid