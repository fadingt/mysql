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
srecedate '实回日期'
from(
select 
      x.*,xx.cnum, 
      case when x.typename='框架协议' then '0' else x2.cstagenum end as cstagenum,
 case when x.typename='框架协议' then '0' else  ifnull(x3.ywcnum,'未确认完成日期') end as ywcnum ,
     x1.zzyjdate,x1.zwyjdate,
      case when x2.cstagenum=x3.ywcnum then '是' else '否'  end yesnoqr 
	from
(select t.contractid,t.contractno,t.contractname,t.typename,translatedict('IDFS000136',t1.effectstatus) effectstatus,t.id as stageid,t.stagename,
case when t.sbillamt is not null then '已开票' else '未开票' end jdzt, -- 阶段状态
t.ybilldate, t.ybillamt, t.yrecedate, t.yreceamt,t.sbilldate, t.sbillamt, t.srecedate, t.sreceamt from t_contract_stage_ys_tian t,t_contract_main t1 
where t.contractid=t1.contractid and t1.effectstatus not in (5,8) and (t.ybilldate >= 20160101 and t.yrecedate >= 20160101) )x
 join 
(select contractid,max(t1.predictenddate) zwyjdate,min(t1.predictenddate) zzyjdate from  t_contract_projectrelation t,t_project_stepbudget t1 where  t.projectid=t1.projectid

   GROUP BY contractid)x1 on x1.contractid=x.contractid
left join (
select count(projectid) cnum,contractid from  t_contract_projectrelation   GROUP BY contractid)xx on xx.contractid=x.contractid
LEFT JOIN(
select count(projectid) cstagenum,stageid from t_contract_project_stage GROUP BY stageid)x2 on x2.stageid=x.stageid

LEFT JOIN(
select  count(jswcrq) ywcnum, stageid from t_contract_project_stage t,t_project_stage_ys_tian t1,t_project_stepbudget t2 where t.projectid=t2.projectid and t.projectstageid=t2.templateid and t.projectid = t1.projectid and t.projectstageid=t1.templateid and (jswcrq !=' ' or jswcrq !=null) GROUP BY stageid 
)x3 on x3.stageid=x.stageid

)x where 1=1
-- {contractno}
-- {contractname}