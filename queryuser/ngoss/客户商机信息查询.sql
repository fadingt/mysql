SELECT
*
/*
businessno,
oppmainno,
left(oppmainno, LENGTH(oppmainno)-3)
*/
FROM
		(SELECT businessid cbbusinessid,-- 客户商机ID
						businessno,-- 客户商机编号
						custid cbcustid,-- 客户ID
						businessname,-- 客户商机名称
						predictsumprice,-- 预计总价
						year cbyear,-- 所属年度
						translatedict('IDFS000079', status) cbstatus,--  '状态(1-未生效，2-已生效，3-变更中)',IDFS000065
						getcustname(custid) custname,-- 客户名称
						applyfigure,-- 客户商机金额
						createdate cbcreatedate,-- 创建时间
						getusername(applyuserid) cbapplyusername
		from t_sale_customerbusiness) cb 
LEFT JOIN 
		(select
					oppid,
					oppmainno,-- '主商机编号',
					businessid bobusinessid,-- 客户商机ID',
					translatedict('IDFS000052', oppstep) oppstepname,-- 商机阶段
					-- oppno,-- 商机编号
					oppname,-- 商机名称
					year boyear,-- 所属年份
					signposibility,-- 签约可能性
					createdate,-- 创建日期
					predicttotalprice,-- 预计项目总价
					getusername(applyuser) applyusername,-- 申请人，项目负责人
					translatedict('IDFS000068', opertype) opertypename,-- '操作类型(1-新增，2-变更)',
					infoex2,-- 项目经理
					infoex3,-- 项目总监
					translatedict('IDFS000078', status) bostatus, -- 项目商机状态(1-未生效，2-已生效，3-变更中',
					getusername(saleid) salename,-- 销售代表',
					saleid,
					prjapplyfigure,-- 项目阶段预算
					oppapplyfigure-- 项目商机阶段预算
		from t_sale_businessopportunity) bo ON bo.bobusinessid = cb.cbbusinessid;

SELECT
businessno, -- 客户商机编号
businessname, -- 客户商机名称
getcustname(custid) custname, -- 客户名称
year, -- 商机年度
-- 销售人员
-- 技术负责人
-- 创建时间
-- 客户商机金额
-- 已转商机数
-- 已转项目商机金额
-- 转项目商机金额占比
-- 已立项数
-- 已立项金额
'|'
FROM t_sale_customerbusiness
/*
查询条件：
客户商机编号、商机年度、销售人员、技术负责人、转项目商机金额占比

使用人：
项目服务部QA 全量查询				业务合规部 全量查询
*/