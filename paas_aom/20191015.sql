set @subLen := 1;
set @yearmonth := 201905;

SELECT
a.*,
case @subLen 
	when 1 then `科目1` when 2 then CONCAT(`科目1`,'-',`科目2`) 
	when 3 then CONCAT(`科目1`,'-',`科目2`,'-',`科目3`)
	when 4 then CONCAT(`科目1`,'-',`科目2`,'-',`科目3`,'-',`科目4`)
END acctname,
b.SUBTYPE
from (
		SELECT 
		left(mxno,2*@subLen+2) mxno, mxname, 
-- 		financialno, financialname, 
		SUM(case when yearmonth < @yearmonth then debit else 0 END) '借方期初余额',
		SUM(case when left(yearmonth,4) < left(@yearmonth,4) then debit else 0 end) '借方年初余额',
		SUM(case when yearmonth = @yearmonth then debit else 0 end) '借方本期发生额',
		SUM(case when left(yearmonth,4) = left(@yearmonth,4) then debit else 0 end) '借方本年累计',
		SUM(debit) '借方期末余额',
		SUM(case when yearmonth < @yearmonth then credit else 0 END) '贷方期初余额',
		SUM(case when left(yearmonth,4) < left(@yearmonth,4) then credit else 0 end) '贷方年初余额',
		SUM(case when yearmonth = @yearmonth then credit else 0 end) '贷方本期发生额',
		SUM(case when left(yearmonth,4) = left(@yearmonth,4) then credit else 0 end) '贷方本年累计',
		SUM(credit) '贷方期末余额'
		from t_snap_fi_voucher voucher
		where yearmonth is not null 
		GROUP BY left(mxno,2*@subLen+2)
)a
left join (
		SELECT 
			a.S_SUBCODEID, a.S_HIERARCHY,
			a1.S_SUBNAME '科目1', a2.s_subname '科目2',
			case when LOCATE('-',a3.S_SUBNAME) <> 0 then SUBSTRING_INDEX(a3.s_subname,'-',-1) else a3.s_subname end '科目3',
			case when LOCATE('-',a4.S_SUBNAME) <> 0 then SUBSTRING_INDEX(a4.s_subname,'-',-1) else a4.s_subname end '科目4',
			b.DICT_NAME SUBTYPE
		FROM `mdl_aos_account` a
		join plf_aos_dictionary b on a.S_SUBTYPE = b.DICT_CODE and b.DICT_TYPE = 'SUBTYPE'
		left join mdl_aos_account a1 on left(a.s_subcodeid,4) = a1.s_subcodeid and a1.S_HIERARCHY = 1
		left join mdl_aos_account a2 on left(a.s_subcodeid,6) = a2.s_subcodeid and a2.S_HIERARCHY = 2
		left join mdl_aos_account a3 on left(a.s_subcodeid,8) = a3.s_subcodeid and a3.S_HIERARCHY = 3
		left join mdl_aos_account a4 on left(a.s_subcodeid,10) = a4.s_subcodeid and a4.S_HIERARCHY = 4
)b on a.mxno = b.S_SUBCODEID
