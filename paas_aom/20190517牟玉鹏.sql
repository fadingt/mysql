select constage.id,unit.S_CONCODE,unit.S_CONNAME,constage.S_STAGEDES S_STAGECODE,unit.S_CONCATE,unit.S_SALEOWNER,(select org_code from plf_aos_auth_user where id=unit.S_SALEOWNER) S_SALEDEPT,unit.S_CUSTNAME,unit.I_FINANCEID,unit.S_BILLCYCLE,
constage.S_STAGEDES,constage.S_BACKSTA,constage.S_BILLSTA,constage.S_ASSSTA,unit.DT_PSIGNDATE,unit.DT_ASIGNDATE,unit.DL_CONAMT,
constage.DT_PREBILLD,constage.DL_BILLAMT,constage.DT_ACBILLD,constage.DL_ACBILLAMT,constage.DT_PREBACKD,constage.DL_BACKAMT,constage.DT_ACAMTD,constage.DL_ACBACKAMT,
unit.create_time DT_APPBILLDT,unit.S_BILLCODE,
0.00 dl_billbf16,0.00 dl_backbf16,0.00 dl_billaf16,0.00 dl_backaf16,
case 
when constage.DL_ACBILLAMT = constage.DL_ACBACKAMT and constage.DL_ACBILLAMT != 0
then TO_DAYS(constage.DT_ACBILLD) - TO_DAYS(constage.DT_ACAMTD)
when constage.DL_ACBILLAMT = 0 or constage.DL_ACBILLAMT is null then 0
when constage.DL_ACBILLAMT > 0 and IFNULL(constage.DL_ACBACKAMT,0) < IFNULL(constage.DL_ACBILLAMT,0)
then TO_DAYS(NOW()) - TO_DAYS(DT_ACBILLD) end `回款周期`,
IFNULL(constage.DL_ACBILLAMT,0) - IFNULL(constage.DL_ACBACKAMT,0) `应收账款`
from MDL_AOS_SACONSTAG constage
inner join (
	select cont.id,cont.S_CONCODE,cont.S_CONNAME,cont.S_CONCATE,cont.DL_CONAMT,cust.S_SALEOWNER,cust.S_CUSTNAME,poinf.I_FINANCEID,cont.S_BILLCYCLE,cont.DT_PSIGNDATE,cont.DT_ASIGNDATE,bill.create_time,bill.S_BILLCODE 
	from MDL_AOS_SACONT cont 
	left join MDL_AOS_SACUSTINF cust on cust.id=cont.I_CUSTID and cust.is_delete='0' 
	left join mdl_aos_sapoinf poinf on poinf.id=cont.I_POID and poinf.is_delete='0' 
	left join MDL_AOS_SABILLAPP bill on bill.I_CONID=cont.id and bill.is_delete='0' 
where cont.is_delete='0') unit  on unit.id = constage.I_CONID and constage.is_delete = '0'

union all 

select rst.id,unit.S_CONCODE,unit.S_CONNAME,unit.S_STAGECODE,unit.S_CONCATE,unit.S_SALEOWNER,
(select org_code from plf_aos_auth_user where id=unit.S_SALEOWNER) S_SALEDEPT, unit.S_CUSTNAME,unit.I_FINANCEID,unit.S_BILLCYCLE,rst.S_STAGEDES,rst.S_BACKSTA,rst.S_BILLSTA,rst.S_ASSSTA,unit.DT_PSIGNDATE,unit.DT_ASIGNDATE,unit.DL_CONAMT,
rst.DT_PREBILLD,rst.DL_BILLAMT,rst.DT_ACBILLD,rst.DL_ACBILLAMT,rst.DT_PREBACKD,rst.DL_BACKAMT,rst.DT_ACAMTD,rst.DL_ACBACKAMT,unit.create_time DT_APPBILLDT,unit.S_BILLCODE,
0.00 dl_billbf16,0.00 dl_backbf16,0.00 dl_billaf16,0.00 dl_backaf16,
case when rst.DL_ACBILLAMT = rst.DL_ACBACKAMT and rst.DL_ACBILLAMT != 0
then TO_DAYS(rst.DT_ACAMTD) - TO_DAYS(rst.DT_ACBILLD)
when rst.DL_ACBILLAMT = 0 or rst.DL_ACBILLAMT is null then 0
when IFNULL(rst.DL_ACBILLAMT,0) >0 and IFNULL(rst.DL_ACBACKAMT,0) < IFNULL(rst.DL_ACBILLAMT,0)
then TO_DAYS(NOW()) - TO_DAYS(rst.DT_ACBILLD) end `回款周期`,
IFNULL(rst.DL_ACBILLAMT,0) - IFNULL(rst.DL_ACBACKAMT,0) `应收账款`
from MDL_AOS_SAORDERST rst 
inner join (
	select tem.id,tem.S_STACODE S_STAGECODE,cont.S_CONCODE,cont.S_CONNAME,cont.S_CONCATE,cont.DL_CONAMT,cust.S_SALEOWNER,cust.S_CUSTNAME,poinf.I_FINANCEID,cont.S_BILLCYCLE,cont.DT_PSIGNDATE,cont.DT_ASIGNDATE,bill.create_time,bill.S_BILLCODE 
	from MDL_AOS_SACONT cont 
	right join MDL_AOS_SASTATEM tem on tem.I_PROTNAME=cont.id and tem.is_delete='0' 
	left join MDL_AOS_SACUSTINF cust on cust.id=cont.I_CUSTID and cust.is_delete='0' 
	left join mdl_aos_sapoinf poinf on poinf.id=cont.I_POID and poinf.is_delete='0' 
	left join MDL_AOS_SABILLAPP bill on bill.I_CONID=cont.id and bill.is_delete='0' 
where cont.is_delete='0') unit  on unit.id = rst.I_STATEID and rst.is_delete = '0' 
