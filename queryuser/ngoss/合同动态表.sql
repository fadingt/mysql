set @yearmonth := 201806;
select  
tttt.*,
tttt.receshiyear+tttt.rece_amt_sum+tttt.receshinow  as recezongji,
tttt.bill_amt_sum+tttt.billshiyear+tttt.billshinow as billzongji,
tttt.bill_amt_sum+tttt.billshiyear+tttt.billshinow -tttt.receshiyear-tttt.rece_amt_sum-tttt.receshinow as ypys,
case when tttt.billbili2=0 then CONCAT(0.00,'%')  when tttt.billbili2 !=0 then tttt.billbili2 end as billbili,
case when tttt.recebili2=0 then CONCAT(0.00,'%')  when tttt.recebili2 !=0 then tttt.recebili2 end as recebili 
from (select
case when ttt.pono is not null  and SUBSTR(ttt.ddtime FROM 1 FOR 4)=SUBSTR(@yearmonth FROM 1 FOR 4) then ifnull(ttt.contractprice,0) 
     when ttt.pono is null   and SUBSTR(ttt.ddtime FROM 1 FOR 4)=SUBSTR(@yearmonth FROM 1 FOR 4) 
     then ifnull(ttt.contractprice,0) else 0 end as jnhtje,
case when ttt.pono is not null  and SUBSTR(ttt.ddtime FROM 1 FOR 6)=SUBSTR(@yearmonth FROM 1 FOR 6) then ifnull(ttt.contractprice,0) 
     when ttt.pono is null   and SUBSTR(ttt.ddtime FROM 1 FOR 6)=SUBSTR(@yearmonth FROM 1 FOR 6) 
     then ifnull(ttt.contractprice,0) else 0 end as dyhtje,
      ttt.bill_amt_sum15+ttt.billshiyear16 as bill_amt_sum,
      ttt.rece_amt_sum15+ttt.receshiyear16 as rece_amt_sum,ttt.* ,

     concat(TRUNCATE((ttt.bill_amt_sum15+ttt.billshiyear16+ttt.billshiyear+ttt.billshinow)/ttt.contractprice*100,2),'%') as billbili2, -- 新加当月实开
     concat(TRUNCATE((ttt.rece_amt_sum15+ttt.receshiyear16+ttt.receshiyear+ttt.receshinow)/ttt.contractprice*100,2),'%') as recebili2, -- 新加当月实回
     ttt.bill_amt_sum15+ttt.billshiyear+ttt.billshiyear16+ttt.billyunow+ttt.billyulate-ttt.contractprice as billyj,
     ttt.rece_amt_sum15+ttt.receshiyear+ttt.receshiyear16+ttt.receyunow+ttt.receyulate-ttt.contractprice as receyj, 
     ttt.bill_amt_sum15+ttt.billshiyear+ttt.billshiyear16+ttt.billshinow+ttt.billyulate-ttt.contractprice as billjy,
     ttt.rece_amt_sum15+ttt.receshiyear+ttt.receshiyear16+ttt.receshinow+ttt.receyulate-ttt.contractprice as recejy 
from (select (case when c2.effectstatus=5  then '是'  else '否' end ) effectstatus ,c2.contractid,c2.billyjc,  c2.contractno,c2.contractname,c2.pono,
c2.ddtime,c2.createtime,c2.type,getusername(c2.saleid) as sale,
(SELECT linename from t_sys_mngunitinfo where unitid = (SELECT deptid from t_sys_mnguserinfo where userid = c2.saleid)) salearea,
getcustname(c2.firstparty)firstparty,c2.secondparty,c2.finalcust as company,
case when c2.type in (2,4) then ifnull(c2.contractprice,0) when c2.type in (1,3) then ifnull(c2.poprice,0) end as contractprice,
case when c2.type in (2,4) then ifnull(i.bill_amt_sum,0)   when c2.type in (1,3) then getOrderBillAmt(c2.id) end as bill_amt_sum15,
case when c2.type in (2,4) then ifnull(i.rece_amt_sum,0)   when c2.type in (1,3) then getOrderReceAmt(c2.id) end as rece_amt_sum15,
ifnull(c2.billyunow,0) billyunow, ifnull(c2.billshinow,0)billshinow, ifnull(c2.billshiyear,0)billshiyear16, ifnull(c2.billshiyear17,0)billshiyear, 
ifnull(c2.billyulate,0)billyulate, ifnull(c2.billshinow,0)-ifnull(c2.billyunow,0) as billcha, ifnull(c2.receyunow,0)receyunow, ifnull(c2.receshinow,0)receshinow, ifnull(c2.receshiyear,0)receshiyear16, ifnull(c2.receshiyear17,0)receshiyear,
ifnull(c2.receyulate,0)receyulate, ifnull(c2.receshinow,0)-ifnull(c2.receyunow,0) as rececha, 
ifnull(c2.billt1,0)billt1,ifnull(c2.billt2,0)billt2,ifnull(c2.billt3,0)billt3,ifnull(c2.billt4,0)billt4,ifnull(c2.billt5,0)billt5,ifnull(c2.billt6,0)billt6,
ifnull(c2.recet1,0)recet1,ifnull(c2.recet2,0)recet2,ifnull(c2.recet3,0)recet3,ifnull(c2.recet4,0)recet4,ifnull(c2.recet5,0)recet5,
ifnull(c2.recet6,0)recet6 from  (select c.*,a1.billyunow,a2.billshinow,a3.billshiyear,a3_2017.billshiyear17, 
a4.billyulate,a5.receyunow,a6.receshinow,a7.receshiyear,a2017.receshiyear17, 
a8.receyulate,t1.billt1,t1.billt2,t1.billt3,t1.billt4,t1.billt5,t1.billt6,t2.recet1,t2.recet2,t2.recet3,t2.recet4,t2.recet5,t2.recet6 from(select 
 cc.lastmodtime1 as ddtime,d1.id,getBillYuJingCout(cc.contractid,0) as billyjc,d1.pono,d1.poprice,cc.* from  (select getcustname(p.finalcustomer)finalcust,c1.*, ctemp.lastmodtime1 from t_contract_main c1
left join(
	SELECT 
		contractid contractid1, lastmodtime lastmodtime1 
	from t_contract_maintmp a 
	join (SELECT MIN(id) id1 from t_contract_maintmp GROUP BY contractid) b on a.id = b.id1
	WHERE status = 3 and type in (2,4)
)ctemp on ctemp.contractid1 = c1.contractid
 join t_contract_projectrelation g on c1.contractid=g.contractid join t_project_projectinfo p on g.projectid=p.projectid where c1.effectstatus not in ('7','8') and c1.type in (2,4) group by c1.contractid )cc
left join ( select sum(poprice) poprice,id,pono,protocolorcontractid from   t_contract_order  where left(createtime, 4) = SUBSTR(@yearmonth FROM 1 FOR 4)  GROUP BY protocolorcontractid  )d1 on cc.contractid=d1.protocolorcontractid)c 
left join (select contractid,sum(billmoney) as billyunow,billyutime as month from view_constage_bill where billyutime=date_format(@yearmonth,'%Y%m') group by contractid)a1 on c.contractid=a1.contractid
left join (
select sum(sbillamt) billshinow,SUBSTR(sbilldate FROM 1 FOR 6) as month,contractid from -- 当月开票固定金额 updatetime3.19
(select * from t_contract_stage_ys_tian where orderid is null)t 
where SUBSTR(sbilldate FROM 1 FOR 6)=date_format(@yearmonth,'%Y%m')group by contractid
ORDER BY contractid)a2 on c.contractid=a2.contractid 
left join (select sum(sbillamt) billshiyear,contractid from (select * from t_contract_stage_ys_tian where orderid is null)t where  SUBSTR(sbilldate FROM 1 FOR 6)>='201601' and SUBSTR(sbilldate FROM 1 FOR 6)<concat(left(date_format('20180308','%Y%m'),4)-1,1231) group by contractid )a3 on c.contractid=a3.contractid 
left join (select sum(sbillamt) billshiyear17,contractid from (select * from t_contract_stage_ys_tian where orderid is null)t where  SUBSTR(sbilldate FROM 1 FOR 6)>=CONCAT(left(@yearmonth,4),'01')  and SUBSTR(sbilldate FROM 1 FOR 6)<date_format(@yearmonth,'%Y%m') group by contractid  ORDER BY contractid)a3_2017 on c.contractid=a3_2017.contractid -- updatetime 3.20
left join (select contractid,sum(billmoney) as billyulate from view_constage_bill where billyutime>date_format(@yearmonth,'%Y%m') group by contractid)a4 on c.contractid=a4.contractid 
left join (select contractid,sum(paymoney) as receyunow from view_constage_rece where receyutime=date_format(@yearmonth,'%Y%m') group by contractid,receyutime)a5 on c.contractid=a5.contractid 
left join (select sum(sreceamt) receshinow,contractid from (select * from t_contract_stage_ys_tian where orderid is null)t where SUBSTR(srecedate FROM 1 FOR 6)=date_format(@yearmonth,'%Y%m') group by contractid ORDER BY contractid)a6 on c.contractid=a6.contractid -- updatetime3.20
left join (select sum(sreceamt) receshiyear,contractid from (select * from t_contract_stage_ys_tian where orderid is null)t where SUBSTR(srecedate FROM 1 FOR 6)>='201601' and SUBSTR(srecedate FROM 1 FOR 6)<concat(left(date_format(@yearmonth,'%Y%m'),4)-1,1231) group by contractid )a7 on c.contractid=a7.contractid  -- updatetime 3.20
left join (select sum(sreceamt) receshiyear17,contractid from (select * from t_contract_stage_ys_tian where orderid is null)t where SUBSTR(srecedate FROM 1 FOR 6)>=CONCAT(left(@yearmonth,4),'01')  and SUBSTR(srecedate FROM 1 FOR 6)<date_format(@yearmonth,'%Y%m') group by contractid)a2017 on c.contractid=a2017.contractid -- updatetime 3.20
left join (select contractid,sum(paymoney) as receyulate from view_constage_rece where receyutime>date_format(@yearmonth,'%Y%m') group by contractid)a8 on c.contractid=a8.contractid 
left join (select tt.contractid,sum(tt.billt1)billt1,sum(tt.billt2)billt2,sum(tt.billt3)billt3,sum(tt.billt4)billt4,sum(tt.billt5)billt5,sum(tt.billt6)billt6 from 
(select t.contractid,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=1 then t.billyu else 0 end as billt1,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))-MONTH(date_format(@yearmonth,'%Y%m%d') )=2 then t.billyu else 0 end as billt2,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=3 then t.billyu else 0 end as billt3,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=4 then t.billyu else 0 end as billt4,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=5 then t.billyu else 0 end as billt5,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=6 then t.billyu else 0 end as billt6 from (select contractid,sum(billmoney) as billyu,billyutime as month from view_constage_bill group by contractid,billyutime)t where t.month>=date_format(@yearmonth,'%Y%m'))tt group by tt.contractid)t1 on c.contractid=t1.contractid  left join (select tt.contractid,sum(tt.recet1)recet1,sum(tt.recet2)recet2,sum(tt.recet3)recet3,sum(tt.recet4)recet4,sum(tt.recet5)recet5,sum(tt.recet6)recet6 from 
(select t.contractid,case when (YEAR(CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 +
MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=1 then t.receyu else 0 end as recet1,
case when (YEAR(CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=2 then t.receyu else 0 end as recet2,
case when (YEAR(CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=3 then t.receyu else 0 end as recet3,
case when (YEAR(CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=4 then t.receyu else 0 end as recet4,
case when (YEAR(CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=5 then t.receyu else 0 end as recet5,
case when (YEAR(CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=6 then t.receyu else 0 end as recet6 from (select contractid,sum(paymoney) as
receyu,receyutime as month from view_constage_rece group by contractid,receyutime)t where t.month>=date_format(@yearmonth,'%Y%m'))tt group by tt.contractid)t2 on c.contractid=t2.contractid 
UNION
 select c.*,b1.billyunow,
b2.billshinow,b3.billshiyear, b3_2017.billshiyear17,b4.billyulate,b5.receyunow,b6.receshinow,b7.receshiyear, 
b7_2017.receshiyear17,b8.receyulate,t1.billt1,t1.billt2,t1.billt3,t1.billt4,t1.billt5,t1.billt6,t2.recet1,t2.recet2,t2.recet3,t2.recet4,t2.recet5,t2.recet6 from (select d1.extend4 as ddtime,d1.id,getBillYuJingCout(d1.id,1) as billyjc,d1.pono,d1.poprice,cc.* from (select getcustname(p.finalcustomer)finalcust,c1.*, null from t_contract_main c1 join t_contract_projectrelation g on c1.contractid=g.contractid join t_project_projectinfo p on g.projectid=p.projectid where c1.effectstatus not in ('7','8')  and c1.type in (1,3)group by c1.contractid)cc join t_contract_order d1 on cc.contractid=d1.protocolorcontractid) c left join (select contractid, pono, sum(j.poprice) as billyunow, billyutime from view_orderstage_bill j where billyutime=date_format(@yearmonth,'%Y%m') group by pono)b1 on c.contractid=b1.contractid and c.pono=b1.pono left join (select sum(f.invoiceamt) as billshinow,s.protocolorcontractid as contractid,d.pono from (select * from t_bill_Invoice  where invoicestatus!=1) f join (select * from t_bill_main where invoicestatus=3) s on f.billingid=s.id 
join (select j.id,j.poid,o.pono,o.protocolorcontractid from t_contract_orderstage j join t_contract_order o on j.poid=o.id)d on s.protocolorcontractid=d.protocolorcontractid and s.orderstageid=d.id
where SUBSTR(f.invoicetime FROM 1 FOR 6)=date_format(@yearmonth,'%Y%m') group by d.pono)b2 on c.contractid=b2.contractid and c.pono=b2.pono 
left join (select sum(sbillamt) billshiyear,contractid,pono from  (select * from t_contract_stage_ys_tian where orderid is not null )t where SUBSTR(sbilldate FROM 1 FOR 6)>='201601' and SUBSTR(sbilldate FROM 1 FOR 6)<concat(left(date_format(@yearmonth,'%Y%m'),4)-1,1231)GROUP BY pono ORDER BY pono)b3 on c.contractid=b3.contractid and c.pono=b3.pono  -- 当年实开不含当月 update 3.19
left join (select sum(sbillamt) billshiyear17,contractid,pono from  --  update 3.19
(select * from t_contract_stage_ys_tian where orderid is not null )t 
where SUBSTR( sbilldate FROM 1 FOR 6)>=CONCAT(left(@yearmonth,4),'01')  and SUBSTR(sbilldate FROM 1 FOR 6)<date_format(@yearmonth,'%Y%m')
GROUP BY pono ORDER BY pono)b3_2017 on c.contractid=b3_2017.contractid and c.pono=b3_2017.pono 
left join (select contractid, pono, sum(j.poprice) as billyulate from view_orderstage_bill j where billyutime>date_format(@yearmonth,'%Y%m') group by pono)b4 on c.contractid=b4.contractid and c.pono=b4.pono 
left join (select contractid, pono, receyutime,sum(paymented)as receyunow from view_orderstage_rece where receyutime=date_format(@yearmonth,'%Y%m') group by pono)b5 on c.contractid=b5.contractid and c.pono=b5.pono -- 当月实回
left join (select sum(sreceamt) receshinow,contractid,pono from  -- 当月回款 updatetime 3.19
(select * from t_contract_stage_ys_tian where orderid is not null )t 
where SUBSTR(srecedate FROM 1 FOR 6)=date_format(@yearmonth,'%Y%m')
GROUP BY contractid,orderid)b6 on c.contractid=b6.contractid and c.pono=b6.pono 
left join (
 select sum(sreceamt) receshiyear,contractid,pono from  -- 往年回款 updatetime 3.19
(select * from t_contract_stage_ys_tian where orderid is not null )t 
where SUBSTR(srecedate FROM 1 FOR 6)>='201601' and SUBSTR(srecedate FROM 1 FOR 6)<concat(left(date_format(@yearmonth,'%Y%m'),4)-1,1231)
GROUP BY contractid,orderid
         )b7 on c.contractid=b7.contractid
and c.pono=b7.pono 
left join (select pp.receshiyear17 ,contractid,pono from (select sum(sreceamt) receshiyear17,contractid,orderid poid,pono from (select * from t_contract_stage_ys_tian where orderid is not null )t where SUBSTR(srecedate FROM 1 FOR 6)>=CONCAT(left(@yearmonth,4),'01')  and SUBSTR(srecedate FROM 1 FOR 6)<date_format(@yearmonth,'%Y%m')  GROUP BY contractid,orderid ORDER BY orderid)pp)b7_2017 on
c.contractid=b7_2017.contractid and c.pono=b7_2017.pono
left join (select contractid,pono, sum(paymented) as receyulate, receyutime as month from view_orderstage_rece j where receyutime>date_format(@yearmonth,'%Y%m') group by pono)b8 on c.contractid=b8.contractid and c.pono=b8.pono 
left join (select tt.contractid,tt.pono,sum(tt.billt1)billt1,sum(tt.billt2)billt2,sum(tt.billt3)billt3,sum(tt.billt4)billt4,
sum(tt.billt5)billt5,sum(tt.billt6)billt6 from (select t.contractid,t.pono,
case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=1 then t.billyu else 0 end as billt1,
case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=2 then t.billyu else 0 end as billt2,
case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=3 then t.billyu else 0 end as billt3,
case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=4 then t.billyu else 0 end as billt4,
case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=5 then t.billyu else 0 end as billt5,
case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=6 then t.billyu else 0 end as billt6 from (select d.protocolorcontractid as contractid,d.pono,sum(j.poprice) as billyu,SUBSTR(j.billingdate FROM 1 FOR 6)as month from t_contract_orderstage j join t_contract_order d on j.poid=d.id group by d.protocolorcontractid,d.pono,SUBSTR(j.billingdate FROM 1 FOR 6))t where t.month>=date_format(@yearmonth,'%Y%m'))tt group by tt.contractid,tt.pono)t1 on c.contractid=t1.contractid and c.pono=t1.pono 
left join (select tt.contractid,tt.pono,sum(tt.recet1)recet1,sum(tt.recet2)recet2,sum(tt.recet3)recet3,sum(tt.recet4)recet4,sum(tt.recet5)recet5,sum(tt.recet6)recet6 from (select t.contractid,t.pono,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=1 then t.receyu else 0 end as recet1,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=2 then t.receyu else 0 end as recet2,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=3 then t.receyu else 0 end as recet3,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=4 then t.receyu else 0 end as recet4,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=5 then t.receyu else 0 end as recet5,case when (YEAR( CONCAT(t.month,'01'))-YEAR(date_format(@yearmonth,'%Y%m%d') ))*12 + MONTH(CONCAT(t.month,'01'))- MONTH(date_format(@yearmonth,'%Y%m%d') )=6 then t.receyu else 0 end as recet6   from (select contractid,pono,sum(paymented) as receyu,receyutime as month from view_orderstage_rece group by pono,receyutime)t where t.month>=date_format(@yearmonth,'%Y%m'))tt  group by tt.contractid,tt.pono)t2 on c.contractid=t2.contractid and c.pono=t2.pono )c2 LEFT JOIN   t_contract_month_income i on c2.contractid=i.contract_id)ttt   )tttt where 1=1
--  {contractno} {contractname} {type} 
order by tttt.sale,tttt.contractno,SUBSTR(tttt.pono FROM 15 FOR 20)+0
;