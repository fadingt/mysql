select  *
from 
(SELECT projectid, projectno as projectno2 ,projecttype, projstatus,deptid,getunitname(deptid) as deptname  FROM t_project_projectinfo
-- WHERE projectname like '%唐山%'
) pinfo 

LEFT JOIN 
(
select 
getcustname(m.firstparty) custname, -- 客户名称
t.contractno,  -- 合同编号
t.contractname,-- 合同名称
t.id,   
t.contractid,  -- 合同编号
t.orderid, 
t.pono, -- 合同编号
t.type,
t.typename,
t.stagename stagedescription,-- 合同阶段
t.ybilldate,-- 欲开时间
t.ybillamt,-- 预计开票金额
t.yrecedate,-- 欲回时间
t.yreceamt,-- 预计回款金额
t.sbilldate,-- 开时间
ifnull(t.sbillamt,0) sbillamt,  -- 实际开票金额
ifnull(t.sreceamt,0) sreceamt,-- 实际回款金额
t.srecedate,-- 实回时间
(select deptid from  t_project_projectinfo where projectid=t.projectid) deptidp,
(select projectno from  t_project_projectinfo where projectid=t.projectid) projectno,
t.projectname,
ifnull(t.f_sbillamt,0)  sallocatebillamt,  -- 预计开票已分配
ifnull(t.f_sreceamt,0)  sallocatepayamt,
ifnull(t.f_ybillamt,0)   allocatebillamt,
ifnull(t.f_yreceamt,0)  allocatepayamt

 from t_contract_stage_ysf_tian t
left join t_contract_main m on m.contractid= t.contractid
) x on pinfo.projectno2=x.projectno

LEFT JOIN
(SELECT projectno as projectno1,projectname as projectname1,predictstartdate,predictenddate,maintenancedate,budgetcontractamout,
sum(jan_yjbg+feb_yjbg+mar_yjbg+apr_yjbg+may_yjbg+jun_yjbg+jul_yjbg+aug_yjbg+sep_yjbg+oct_yjbg+nov_yjbg+dec_yjbg) as yjbg, -- yjbg预计报工
sum(jan_sjbg+feb_sjbg+mar_sjbg+apr_sjbg+may_sjbg+jun_sjbg+jul_sjbg+aug_sjbg+sep_sjbg+oct_sjbg+nov_sjbg+dec_sjbg) as sjbg, -- 实际报工
sum(jan_sjcb+feb_sjcb+mar_sjcb+apr_sjcb+may_sjcb+jun_sjcb+jul_sjcb+aug_sjcb+sep_sjcb+oct_sjcb+nov_sjcb+dec_sjcb) as rlcb, -- 人力成本
sum(jan_sjfyb+feb_sjfyb+mar_sjfyb+apr_sjfyb+may_sjfyb+jun_sjfyb+jul_sjfyb+aug_sjfyb+sep_sjfyb+oct_sjfyb+nov_sjfyb+dec_sjfyb) as fy -- 费用
from t_report_projectinfoinout 
GROUP BY projectid
) p on p.projectno1=pinfo.projectno2
WHERE deptid in (30860,
30864,
30866,
30867,
30870,
30874)
and contractid is null
 -- and projectno2 like '%YY-2017-0015-02%'
order by projectno2, deptname

-- SELECT unitid FROM t_sys_mngunitinfo WHERE unitname like '%华北应用开发%'
-- 30839
SELECT projstatus from t_project_projectinfo
WHERE projectno like 'YY-2017-0015-02'

SELECT * from t_report_projectinfoinout
WHERE projectno like 'YY-2017-0015-02'

