
	SELECT 
		projectno, projectname, -- 项目id 编号 名称
		createtime,
		getusername(pm) as pmname, getusername(pd)pdname,-- 项目经理 总监
		translatedict('IDFS000283',businesstype),
		getunitname(gatheringunitid)signcompany,-- 签约公司
		DATE_FORMAT(predictstartdate, '%Y-%m-%d') predictstartdate,-- 预计项目开始时间
		DATE_FORMAT(predictenddate, '%Y-%m-%d') predictenddate,-- 预计项目结束时间
       d.purchasecost,-- 采购总成本
       d.basiccosttotal,-- 人天成本
       d.costtotal, -- 费用合计
       d.totalamt, -- 预算总成本
description,budgetremark
	from  t_project_projectinfo p
left join (
SELECT 
       d.purchasecost,-- 采购总成本
       d.basiccosttotal,-- 人天成本
       d.costtotal, -- 费用合计
       d.totalamt, -- 预算总成本
projectid
from t_project_developbudget d
)d on p.projectid = d.projectid
	where 1=1
and SUBSTRING(predictstartdate,1,4) in (2017,2018)
 and projecttype = 5