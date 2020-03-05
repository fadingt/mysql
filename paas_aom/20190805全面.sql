SELECT
-- budgetno, yearmonth, debit, busitypename, busino, mxno, mxname, zzno, credit
-- DISTINCT zzno
-- , mxname
SUM(debit), budgetno
-- SUM(debit), budgetno, SUBSTRING_INDEX(budgetno,'-',1), yearmonth
from t_snap_fi_voucher a 
join (
	SELECT ID, S_PRJNO
	from mdl_aos_project
	where S_PRJTYPE = 'yy'
)b on a.budgetno = b.s_prjno
where yearmonth is not null
and a.dc='01'
and budgetno is not NULL and budgetno <> '' and budgetno <> '12'
-- and zzno <> 6001
-- and busitype <> 28002
-- 差旅
and busitype not in (22002,27001,23002,24002, 26001)
-- 标准成本-工资 标准成本-13薪奖金 实际成本 标准成本差异 收入核算
-- and SUBSTRING_INDEX(budgetno,'-',1) = 'yy'
and zzno = 6401
-- and zzno <> 6401 and debit <> 0
-- and mxno not in (140501,140502,14050333,14050334,600101,600102,640133,640134)
-- and budgetno = 'YY-2019-0321-42-283'
-- and yearmonth = 201906
GROUP BY budgetno
-- , yearmonth