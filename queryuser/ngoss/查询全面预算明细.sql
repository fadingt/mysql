select x.*,t.remark4 deptname, sqys.buno beiyong from (
select  type,budgetno,budgetname,unitid,chargeperson,jianliren,ifnull(gfamt,0)gfamt,ifnull(gfamty,0) gfamty,ifnull(gramt,0)gramt,ifnull(gramty,0) gramty,year 
from (
select  
type,
typevalue,
budgetid,
budgetno,
budgetname,
tall.unitid,
chargeperson,
jianliren,
gfamt,
gfamty,
gramt,
gramty,
tall.year
from (

	select tf.budgetid,'管理预算' as type,2 as typevalue,ifnull(budgetno,'无编号') budgetno,budgetname,departmentid unitid ,getusername(chargeperson) chargeperson, jianliren, gfamt,gramt,tf.year  
	 from  
	(select tt.budgetid,budgetno,budgetname,departmentname as deptname, chargeperson,getusername(registerid) jianliren,budgetamount gfamt,tt.infoex2 gramt,departmentid,left(createtime,4) year  from  t_budget_deptannualbudget t
		LEFT JOIN  t_budget_deptlevelcost tt on t.budgetid=tt.budgetid 
	) tf 
	UNION all
	select projectid,'管理预算' as type,0 as typevalue,tall.projectno,tall.projectname,tall.deptid,tall.ysfuzeren,tall.yscjren,tall.dfamt,tall.dramt,tall.year
	from (
	select 
p.projectid,
	ifnull(costtotal,0)+ifnull(purchaseproductcost,0)+ifnull(purchaseservicecost,0) dfamt,
	basiccosttotal dramt,
	 projectno,
	projectname,
	 getusername(pd)ysfuzeren,
	getusername(createid) yscjren,
	deptid ,
	left(t.createtime,4) year
	from t_project_developbudget t,t_project_projectinfo p WHERE t.projectid=p.projectid AND p.projecttype=8
		 )tall   

		UNION ALL -- ==================================================================================

	select projectid,'研发预算' as type,0 as typevalue,tall.projectno,tall.projectname, (tall.deptid)deptname,tall.ysfuzeren,tall.yscjren,tall.dfamt,tall.dramt,tall.year
	from (
	select 
p.projectid,
	
	ifnull(costtotal,0)+ifnull(purchaseproductcost,0)+ifnull(purchaseservicecost,0) dfamt,
	basiccosttotal dramt,
	 projectno,
	projectname,
	 getusername(pd)ysfuzeren,
	getusername(createid) yscjren,
	deptid ,
	left(t.createtime,4) year
	from t_project_developbudget t,t_project_projectinfo p WHERE t.projectid=p.projectid AND p.projecttype=5 
		 )tall 

	UNION ALL   -- ==================================================================================
	select tall.budgetid,'销售预算' as type, 3 as typevalue,t1.extend1,t1.budgetname, (tall.unitid),t1.budgetprincipalname,t1.username,tall.salelimit mfamt,tall.saledayscost mramt,tall.year
	 from (select * from t_sale_marketingbudget where year=2018) tall
	left JOIN (
	select * from 
	t_budget_selfbudget where budgetcategory=01 and budgettype = '11' and left(enddate,4)=2018 )t1
	on tall.userid=t1.userid 

	UNION ALL -- ==================================================================================

	select presaleid,'售前预算' as type,1 as typevalue,presaleno,businessname, (tall.deptid),principalname,getusername(userid),predictexpense as  pfamt,infoex3 as pramt,tall.year from T_Sale_Presales tall
)tall

LEFT JOIN ( --  已使用费用
select 
extend1,
sum(totalused) gfamty,
budgetdeptid ,
left(enddate,4)year 
from t_budget_selfbudget  -- where extend1 like '%qt%' or extend1 like '%BM%' 
GROUP BY extend1,left(enddate,4)

)t3 on  
tall.year=t3.year and t3.extend1 = tall.budgetno


LEFT JOIN   -- 人天
(
	select 
	sum(gramt) gramty,count(*) grcon,deptid,year,targetid,lineid,workhourtype
	from(

select gramt,deptid,year,targetid,workhourtype from (
select workdays*defaultcost as gramt,staf_leve,defaultcost,departmentid deptid,year,targetid,workhourtype from 
						 (
			   select employeeid,sum(workdays) workdays,departmentid,year,targetid,workhourtype from (
						select sum(workdays) as workdays,employeeid,departmentid,year,targetid,workhourtype 
						FROM (
									 select employeeid,sum(workhours)/8.0 as workdays,departmentid,left(yearmonthday,4) year,t.targetid ,workhourtype from t_project_workhourmanager t
									 where  left(yearmonthday,6) &#60;= DATE_FORMAT(now(),'%Y%m') 
											 -- 	and t.workhourtype =2 
											and `status` in (2,3) GROUP BY employeeid,targetid 
							) a  GROUP BY employeeid,targetid
			) x  GROUP BY employeeid,targetid   ) aa
							LEFT JOIN 
						 		t_sys_mnguserinfo on employeeid = userid
						  left join t_public_levelcost cost on staf_leve = postlevel ) x
	
	)x,t_sys_mngunitinfo t where t.unitid=x.deptid and t.isdel=0 GROUP BY  year,targetid,workhourtype
)tr on  tall.year=tr.year  and ( tr.targetid=tall.budgetid) and tr.workhourtype=tall.typevalue-- and tr.deptid=tall.unitid 


)xx where 1=1  



and (gfamt is not null or gramt is not null)   and year &#62;=2018

)x
LEFT JOIN (SELECT unitid, remark4 from t_sys_mngunitinfo WHERE isdel =0 ) t on x.unitid = t.unitid
LEFT JOIN (SELECT presaleid, presaleno, projbusinessno buno FROM T_Sale_Presales) sqys on sqys.presaleno = x.budgetno
where 1=1
{unitid}
 {deptname}
 {type}
{year}
{budgetno}
{budgetname}