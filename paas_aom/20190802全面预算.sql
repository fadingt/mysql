SELECT
budgetid, budgetno, yearmonth, 
case when budgettype = 'yy' and busitype = 28002 then 0 else debit END amt, 
busitype, busitypename, zzno, mxno, mxname
,voucherno, busino
from t_snap_fi_voucher
where yearmonth is not null
and budgetno is not NULL
and zzno != 6001
-- and mxno not in (140501,140502,14050333,14050334,600101,600102,640133,640134)
and budgetno = 'YY-2016-0264-01'

-- 1.业务类型不是：标准成本-工资 标准成本-13薪奖金 实际成本 标准成本差异之一的
-- 2.科目非(140501,140502,14050333,14050334,600101,600102,640133,640134)的(这是采购)
-- 3.借方金额
-- 4.若YY项目 则业务类型非差旅费
-- 5.科目非6001开头（收入科目）