select b.*, contract.isfile  from (
select 
xx.pnm,
xx1.cnm,
xx.contractid,
xx1.projectid,
m.contractname,
p.projectname,
m.contractno,
p.projectno,
getunitname(m.company) htyf,
getunitname(p.gatheringunitid) xmyf,

case when xx.pnm=xx1.cnm and xx.pnm=1  then 1
     when xx.pnm>xx1.cnm and xx1.cnm=1 then

(select  GROUP_CONCAT(projectno)as cc from 
(select contractid,projectno from t_contract_projectrelation t
 join (select projectno,projectid as pid from t_project_projectinfo GROUP BY projectid)p on t.projectid=p.pid)x
 where t.contractid=x.contractid GROUP BY  x.contractid  )

       --   when xx.pnm<xx1.cnm and xx.pnm=1 then 3
  end  as hgx,

case when xx.pnm=xx1.cnm and xx1.cnm=1  then 1
     when xx1.cnm>xx.pnm and xx.pnm=1 then 

(select  GROUP_CONCAT(contractno)as cc from 
(select contractid,p.contractno,projectid from t_contract_projectrelation t
 join (select contractno,contractid as pid from t_contract_main m GROUP BY contractid)p on t.contractid=p.pid)x
 where t.projectid=x.projectid GROUP BY  x.projectid  )

        --   when xx1.cnm>xx.pnm and xx.pnm=1 then 3
  end  as xgx
 from t_contract_projectrelation t


 join (select * from t_contract_main GROUP BY contractid )m on m.contractid=t.contractid
 join (select * from t_project_projectinfo GROUP BY projectid)p on t.projectid=p.projectid
join 
(select count(projectid) as pnm,contractid from  t_contract_projectrelation   GROUP BY contractid)xx on t.contractid=xx.contractid
 join 
(select count(contractid) as cnm,projectid from  t_contract_projectrelation   GROUP BY projectid)xx1 on t.projectid=xx1.projectid
left JOIN(

select 
cid,
sum(ifnull(case when year=2015 then bill else 0 end,0)) bill5,
sum(ifnull(case when year=2016 then bill else 0 end,0)) bill6,
sum(ifnull(case when year=2017 then bill else 0 end,0)) bill7,
sum(ifnull(case when year=2015 then rece else 0 end,0)) rece5,
sum(ifnull(case when year=2016 then rece else 0 end,0)) rece6,
sum(ifnull(case when year=2017 then rece else 0 end,0)) rece7

 from (
select contractid as cid,sum(sbillamt) bill,sum(sreceamt) rece,year from (
select contractid,contractno,sbillamt,sreceamt,left(srecedate,4) year from t_contract_stage_ys_tian t
union ALL
select contract_id,contract_no,bill_amt_sum,rece_amt_sum,left(income_month,4) from t_contract_month_income t
)x GROUP BY contractid,`year` )cc GROUP BY cid

) c on  c.cid=t.contractid 

)b 
left join (
		select contractid contractid2, isfile
		from t_contract_main
) contract on contract.contractid2 = b.contractid
left join
(
		SELECT 
			projectid projectid2,
			saleid, pd, pm, finalcustomer,deptid,
			cust.tecpersonid
		from t_project_projectinfo project 
		join t_sale_custbasicdata cust on project.finalcustomer = cust.custid
) chown on chown.projectid2 = b.projectid
where 1=1 
-- and (chown.deptid in (:roledatascope) or :currentuser in (chown.pd, chown.pm, chown.tecpersonid, chown.saleid))
-- {contractno}
-- {contractname}
-- {projectno}
-- {projectname}
-- {hgx}
-- {xgx}

ORDER BY b.contractno 