-- 查询本部门的合同分配项目明细表 contract_main_pro_br
select * from (
select 
getcustname(m.firstparty) custname,
t.contractno,
t.contractname,
t.id,
t.contractid,
m.deptid,
t.orderid,
t.pono,
t.type,
t.typename,
t.stagename stagedescription,
t.ybilldate,
t.ybillamt,
t.yrecedate,
t.yreceamt,
t.sbilldate,
ifnull(t.sbillamt,0) sbillamt,
ifnull(t.sreceamt,0) sreceamt,
t.srecedate,
(select deptid from  t_project_projectinfo where projectid=t.projectid) deptidp,
(select projectno from  t_project_projectinfo where projectid=t.projectid) projectno,
t.projectname,
ifnull(t.f_sbillamt,0)  sallocatebillamt,
ifnull(t.f_sreceamt,0)  sallocatepayamt,
ifnull(t.f_ybillamt,0)   allocatebillamt,
ifnull(t.f_yreceamt,0)  allocatepayamt

 from t_contract_stage_ysf_tian t
left join t_contract_main m on m.contractid= t.contractid
) x
where 1=1 
-- and deptidp in (:roledatascope)
-- {contractno}
-- {contractname}
-- {custname}
