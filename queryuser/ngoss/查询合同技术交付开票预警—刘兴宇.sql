select  
	contractno '合同编号',
	contractname '合同名称',
	typename '合同类型',
	effectstatus '合同状态',
	cnum '合同关联项目数',
	stagename '合同阶段',
	jdzt '阶段状态',
	cstagenum '阶段关联项目数',
	ywcnum '已确认完成数',
	zzyjdate '预计最早完成',
	zwyjdate '预计最晚完成',
	yesnoqr '是否全部确认',
	ybillamt '预开',
	ybilldate '预开日期',
	yreceamt '预回',
	yrecedate '预回日期',
	sbillamt '实开',
	sbilldate '实开日期',
	sreceamt '实回',
	srecedate '实回日期',
	custname '客户',
	tecpersonname '客户经理',
	tecpersonunit '客户经理部门',
	salename '销售',
	salearea '销售所属大区'

from(
select 
      x.*,xx.cnum, x4.custname, x4.tecpersonname, x4.salename, x4.salearea, x4.tecpersonunit,
      case when x.typename='框架协议' then '0' else x2.cstagenum end as cstagenum,
 case when x.typename='框架协议' then '0' else  ifnull(x3.ywcnum,'未确认完成日期') end as ywcnum ,
     x1.zzyjdate,x1.zwyjdate,
      case when x2.cstagenum=x3.ywcnum then '是' else '否'  end yesnoqr 
	from
(select t.contractid,t.contractno,t.contractname,t.type, t.typename,translatedict('IDFS000136',t1.effectstatus) effectstatus,t.id as stageid,t.stagename,
case when t.sbillamt is not null then '已开票' else '未开票' end jdzt, -- 阶段状态
t.ybilldate, t.ybillamt, t.yrecedate, t.yreceamt,t.sbilldate, t.sbillamt, t.srecedate, t.sreceamt from t_contract_stage_ys_tian t,t_contract_main t1 
where t.contractid=t1.contractid and t1.effectstatus not in (5,8) and (t.ybilldate >= 20160101 and t.yrecedate >= 20160101) )x
--  join 
-- (select contractid,max(t1.predictenddate) zwyjdate,min(t1.predictenddate) zzyjdate from  t_contract_projectrelation t,t_project_stepbudget t1 where  t.projectid=t1.projectid
-- 
--    GROUP BY contractid)x1 on x1.contractid=x.contractid
LEFT JOIN
(
	SELECT
		t3.contractid, t3.id stageid,
		MAX(predictenddate) zwyjdate,
		MIN(predictenddate) zzyjdate
	from 
		t_contract_project_stage t1, 
		t_project_stepbudget t2,
		t_contract_stage_ys_tian t3
	WHERE 
		t1.projectid = t2.projectid and t1.projectstageid = t2.templateid
		AND t1.extend1 = t3.type and t1.stageid = t3.id
	GROUP BY
		t3.type, t3.id
) x1 on x1.contractid = x.contractid and  x.stageid = x1.stageid
left join (
select count(projectid) cnum,contractid from  t_contract_projectrelation   GROUP BY contractid)xx on xx.contractid=x.contractid
LEFT JOIN(
select count(projectid) cstagenum,stageid from t_contract_project_stage GROUP BY stageid)x2 on x2.stageid=x.stageid

LEFT JOIN(
select  count(jswcrq) ywcnum, stageid from t_contract_project_stage t,t_project_stage_ys_tian t1,t_project_stepbudget t2 where t.projectid=t2.projectid and t.projectstageid=t2.templateid and t.projectid = t1.projectid and t.projectstageid=t1.templateid and (jswcrq !=' ' or jswcrq !=null) GROUP BY stageid 
)x3 on x3.stageid=x.stageid

LEFT JOIN
(
	SELECT 
		t3.*, saleid, finalcustomer,
		getusername(saleid) salename,
		(SELECT getunitname(parentunitid) from t_sys_mngunitinfo WHERE unitid = (SELECT deptid from t_sys_mnguserinfo WHERE userid = t1.saleid)) salearea, -- 销售代表所属销售大区
		t2.custname custname,
		t2.tecpersonid,
		getusername(t2.tecpersonid) tecpersonname, -- 客户经理/技术负责人
		(SELECT unitname from t_sys_mngunitinfo WHERE unitid = (SELECT deptid from t_sys_mnguserinfo WHERE userid = t2.tecpersonid)) tecpersonunit -- 客户经理部门
	from t_project_projectinfo t1
	join t_sale_custbasicdata t2
		on t1.finalcustomer = t2.custid
	join (SELECT projectid,  stageid, id, extend1 from t_contract_project_stage GROUP BY extend1, stageid) t3 
		on t1.projectid = t3.projectid 
	GROUP BY t3.extend1, t3.stageid
) x4 on x4.extend1 = x.type and x4.stageid = x.stageid
)x where 1=1
-- {contractno}
-- {contractname}