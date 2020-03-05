=INT(IF(I6>$D$2,0,IF(I6>$D$1,($D$2-I6)/$D$3*N6,N6)))

if(入职日期>2019/12/31){
	0
}else if(入职日期>2019/1/1){
	(2019/12/31 - 入职日期)/全年总天数*法定年假基数
}else{
	法定年假基数
}

2019/12/31:
SELECT
MAX(DT_CANDAY)
from mdl_aos_canlender
where year(DT_CANDAY) = year(NOW())
2019/1/1:
SELECT
MIN(DT_CANDAY)
from mdl_aos_canlender
where year(DT_CANDAY) = year(NOW())

法定年假基数：

=IFERROR(SUM(
ABS(
DATE(YEAR($D$1),
MONTH(L6),
DAY(L6))-
DATE(YEAR($D$1)+{0,1},
1,
1))
*LOOKUP(DATEDIF(L6,$D$2,"y")-{1,0},{0,0;1,5;10,10;20,15})
)
/$D$3
,0)

2019 社会工龄起始日期月 社会工龄起始日期天
-
2019 01 01
绝对值
* 根据社会工龄-2019对照应休天数
/全年天数
全年天数：
SELECT
COUNT(*)
from mdl_aos_canlender
where year(DT_CANDAY) = year(NOW())

社会工龄：=IF(K6>J6,K6,MIN(K6,J6))
if(参加工作日期 > 毕业日期){
	参加工作日期
}else{
	毕业日期
}

奖励天数： 根据当年司龄对照: (当年(2019) - 入职日期年)

当年司龄：=IFERROR(
DATEDIF(
I6,
DATE(YEAR($D$1),MONTH(I6),DAY(I6)),"M")
,0)