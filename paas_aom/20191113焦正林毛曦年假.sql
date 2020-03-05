/*建表*/
CREATE TABLE ngoss.`t_snap_annualvacation` (
  `s_year` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL COMMENT '员工姓名',
  `S_EMPTYPE` varchar(255) DEFAULT NULL COMMENT '人员状态',
  `officalVacationDays` double(11) DEFAULT NULL COMMENT '当年法定年假（天）',
  `rewardVacationDays` double(11) DEFAULT NULL COMMENT '当年奖励年假（天）',
  `nowVacationDays` double(11) DEFAULT NULL COMMENT '当年年假总（天）',
	`oldVacationDays` double(11) DEFAULT NULL COMMENT '往年结转年假（天）',
	`onVacationDays` double(11) DEFAULT NULL COMMENT '当年已休（天）',
  `DT_WORKING` datetime DEFAULT NULL COMMENT '参加工作日期',
  `DT_LEAVETIME` datetime DEFAULT NULL COMMENT '离职日期',
  `DT_ENTERTIME` datetime DEFAULT NULL COMMENT '入职日期',
  `DT_HireTime` datetime DEFAULT NULL COMMENT '转正日期',
  `DT_GRADUATE` datetime DEFAULT NULL COMMENT '毕业日期',
  `DT_SocialBegin` datetime DEFAULT NULL COMMENT '社会工龄起始日期',
  `last_update_time` datetime DEFAULT NULL COMMENT '最后更新日期',
  PRIMARY KEY (`userid`,`s_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*初始化数据*/


insert into ngoss.t_snap_annualvacation(s_year, userid, username, officalVacationDays, 
rewardVacationDays, nowVacationDays, oldVacationDays, onVacationDays, last_update_time)
SELECT
2018, b.userid, b.username, a.`当年应休`, a.`奖励天数`, a.`当年应休`, a.`上年结转（天）`, a.`当年已休`, NOW()
from (
	SELECT
	sum_vacationdate `当年应休`,
	now_vacationdate `本年休假（不含奖励天数）`,
	old_vacationdate `上年结转（天）`,
	uservacationdate `当年已休`,
	reward_vacationdate `奖励天数`,nowyear,
	userid  
	from ngoss.t_hr_annualleave 
	where nowyear = 2018
)a
left join ngoss.t_sys_mnguserinfo b on a.userid = b.userid;
/*
NOTE: 
1.新员工转正后可享受当年年假，年假大致是：累计工作已满1年不满10年的，年休假5天；已满10年不满20年的，年休假10天；已满20年的，年休假15天
2.当年年假的计算公式为：
    2.1若入职日期大于当年最后一天 则为0天
    2.2若入职日期大于当年第一天 则为：当年入职天数/全年总天数 * 法定年假基数
    2.3以上两点不满足 则为：法定年假基数
3奖励年假计算方式为：司龄超过1年后每工作一年奖励一天。但年假+奖励年假超过15天后本年应休按15天计算。
*/
SELECT
t1.s_year `年度`, t1.firstday, t1.lastday, t1.days,
12*(t1.s_year-year(t.`入职日期`)) `司龄/月`,
case when t1.s_year > 1+year(t.`入职日期`) then (t1.s_year-year(t.`入职日期`))-1 else 0 END `奖励年假`,
t.usercode,
t.`员工姓名`,
t.`性别`,
t.`人员状态`,
-- t2.userdeptname `员工所属部门`,
t.`员工所属部门`,
t.`毕业日期`,
t.`参加工作日期`,
t.`入职日期`,
t.`离职日期`,
t.`社会工龄起始日期`, 
IFNULL(t2.`当年已休/天`,0) `当年已休/天`,
case 
when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days < 2 then 5*ABS(DATEDIFF(t.`社会工龄起始日期`, t1.firstday)%t1.days)/t1.days
when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days BETWEEN 2 and 9 then 5
when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days BETWEEN 10 and 19 then 10
else 15 END `法定年假基数`,
FLOOR(
case when t.`入职日期` > t1.lastday then 0 
when t.`入职日期` > t1.firstday THEN DATEDIFF(t1.lastday,t.`入职日期`)/t1.days *
		case 
		when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days < 2 then 5*ABS(DATEDIFF(t.`社会工龄起始日期`, t1.firstday)%t1.days)/t1.days
		when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days BETWEEN 2 and 9 then 5
		when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days BETWEEN 10 and 19 then 10
		else 15 END
else 
		case 
		when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days < 2 then 5*ABS(DATEDIFF(t.`社会工龄起始日期`, t1.firstday)%t1.days)/t1.days
		when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days BETWEEN 2 and 9 then 5
		when DATEDIFF(t1.lastday,t.`参加工作日期`)/t1.days BETWEEN 10 and 19 then 10
		else 15 END
 END
)`法定年假`
from (
	SELECT
ngoss.getfullorgname(ORG_CODE) `员工所属部门`,
		S_ENTERTIME `入职日期`, S_LEAVETIME `离职日期`, S_HireTime `转正日期`, DT_WORKING `参加工作日期`,
		DT_GRADUATE `毕业日期`, case when DT_WORKING > DT_GRADUATE then DT_WORKING else DT_GRADUATE end `社会工龄起始日期`, 
		s_name `员工姓名`, LOWER(SUBSTRING_INDEX(S_NAME,'-',-1)) usercode, I_USERID, 
		(SELECT DICT_NAME from plf_aos_dictionary where DICT_CODE = S_EMPTYPE and DICT_TYPE = 'types') `人员状态`,
		case S_GENDER when 1 then '男' when 2 then '女' end `性别`
	from mdl_aos_empstaff where IS_DELETE = 0
)t 
join (
	SELECT 
	year(DT_CANDAY) s_year, COUNT(*) days, MAX(DT_CANDAY) lastday, MIN(DT_CANDAY) firstday
	from mdl_aos_canlender
	where YEAR(DT_CANDAY) <= year(NOW())
)t1 
left join (
	SELECT
	userid, username, SUM(worktimes) `当年已休/天`, left(yearmonth,4) s_year, userdeptname
	from t_snap_daily_workinghours_detail
	where dailytype = 3 and appstatus = 1
	GROUP BY userid, left(yearmonth,4)
)t2 on t.I_USERID = t2.userid and t1.s_year = t2.s_year
where 1=1
-- and t.`员工姓名` = '田田-A4508'
-- and t.`员工姓名` = '刘兴宇-A6853'
-- and t.`员工姓名` = '焦正林-A0025'
-- and t.`员工姓名` = '陈登军-A7053'
and t.`员工姓名` = '张强强-A8698'
;


/*老OA结转*/
SELECT
a.*, b.username
from (
	SELECT
	sum_vacationdate `当年应休`,
	now_vacationdate `本年休假（不含奖励天数）`,
	old_vacationdate `上年结转（天）`,
	uservacationdate `当年已休`,
	reward_vacationdate `奖励天数`,nowyear,
	userid  
	from ngoss.t_hr_annualleave 
	where nowyear = 2018
)a
left join ngoss.t_sys_mnguserinfo b on a.userid = b.userid
where b.username in(
'焦正林-A0025',
'王喆-A2073',
'田田-A4508',
'高雪-A5792',
'王冉-A5808',
'何义-A6991',
'陈登军-A7053',
'刘兴宇-A6853',
'李霄喆-A7514',
'杜昌荣-A8058'
)
