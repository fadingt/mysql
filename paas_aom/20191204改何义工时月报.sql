set @yearmonth :=201911;
SELECT 
		userid as S_STAFFID,username as S_STAFFNAME,
		yearmonth, S_YEAR,	S_MONTH,
		r.S_SHOULDDAY, r.S_HOLIDAY,
    SUM(worktimes)+SUM(CASE WHEN datetype='3' THEN 1 ELSE 0 END) AS S_TRUEDAY,
    SUM(CASE WHEN dailytype='0' THEN worktimes ELSE 0 END) AS S_LOCAL,
    SUM(CASE WHEN dailytype='11' THEN worktimes ELSE 0 END) AS S_RELAX,
    SUM(CASE WHEN (dailytype='1' OR dailytype='2') AND datetype='1' THEN worktimes ELSE 0 END) AS S_WORKTRAVE,
    SUM(CASE WHEN (dailytype='1' OR dailytype='2') AND datetype!='1' THEN 1 ELSE 0 END) AS S_LAXTRAVE,
    SUM(CASE WHEN dailytype='6' THEN worktimes ELSE 0 END) AS S_LEAVEDAY,
    SUM(CASE WHEN dailytype='7' THEN worktimes ELSE 0 END) AS S_ILLDAY,
    SUM(CASE WHEN (dailytype='8' AND datetype='1') THEN worktimes ELSE 0 END) AS S_WORKPRODU,
    SUM(CASE WHEN (dailytype='8' AND datetype!='1' )THEN 1 ELSE 0 END) AS S_RELAXPROD,
    SUM(CASE WHEN dailytype='9' THEN worktimes ELSE 0 END) AS S_CHECKPROD,
    SUM(CASE WHEN dailytype='4' THEN worktimes ELSE 0 END) AS S_MARRYDAY,
    SUM(CASE WHEN dailytype='3' THEN worktimes ELSE 0 END) AS S_YEARDAY,
    SUM(CASE WHEN dailytype='5' THEN worktimes ELSE 0 END) AS S_LOSTDAY,
    SUM(CASE WHEN dailytype='10' THEN worktimes ELSE 0 END) AS S_WITHPRODU,
    SUM(CASE WHEN dailytype='12' THEN worktimes ELSE 0 END) AS S_INJURYDAY,
    0 AS S_LUNCH,0 AS S_DINNER,0 AS S_OVERTIME,
    enterdate AS S_ENTRYDATE,leavedate AS S_LEAVEDATE,tsfdate AS S_FORMAL,emptypename AS S_EMPTYPE,
    '所属公司' AS S_COMP,userdeptname AS S_ORG,
    case when date_format(enterdate,'%Y%m')= d.yearmonth
		then (SELECT count(ID) AS count FROM mdl_aos_canlender WHERE S_CANTYPE = 1 AND IS_DELETE = 0
				AND date_format(DT_CANDAY,'%Y%m') =DATE_FORMAT(enterdate,'%Y%m')
				and date_format(DT_CANDAY,'%Y%m')=d.yearmonth
				AND DT_CANDAY < enterdate) else 0 end DL_ENTRY,
    case when leavedate is null or date_format(leavedate,'%Y%m')!=d.yearmonth
		then 0 else (SELECT count(ID) AS count FROM mdl_aos_canlender WHERE S_CANTYPE = 1 AND IS_DELETE = 0 
				AND date_format(DT_CANDAY,'%Y%m') =DATE_FORMAT(leavedate,'%Y%m')
				and date_format(DT_CANDAY,'%Y%m')=d.yearmonth
				AND DT_CANDAY > leavedate) end DL_QUIT,

    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate<tsfdate then worktimes else 0 end) DL_FFORMAL,
    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate>=tsfdate then worktimes else 0 end) DL_TFROMAL,
    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate<tsfdate AND dailytype='7' then worktimes else 0 end) DL_FFSICK,
    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate>=tsfdate AND dailytype='7' then worktimes else 0 end) DL_TFSICK,
    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate<tsfdate AND dailytype='6' then worktimes else 0 end) DL_FFABSENCE,
    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate>=tsfdate AND dailytype='6' then worktimes else 0 end) DL_TFABSENCE,
    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate<tsfdate AND dailytype='8' then worktimes else 0 end) DL_FFORMALCJ,
    sum(case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
			then 0 when workdate>=tsfdate AND dailytype='8' then worktimes else 0 end) DL_TFORMALCJ, 
    case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
		then 0 else (select count(1) from mdl_aos_canlender where is_delete=0 and S_CANTYPE='1' 
			and d.yearmonth=date_format(DT_CANDAY,'%Y%m') 
			and DT_CANDAY<tsfdate)-sum(case when workdate<tsfdate then worktimes else 0 end) end DL_FFORMALQQ,
    case when tsfdate is null or date_format(tsfdate,'%Y%m')!=d.yearmonth
		then 0 else (select count(1) from mdl_aos_canlender where is_delete=0 and S_CANTYPE='1' 
			and d.yearmonth=date_format(DT_CANDAY,'%Y%m') 
			and DT_CANDAY>=tsfdate)-sum(case when workdate>=tsfdate then worktimes else 0 end) end DL_TFORMALQQ, 
    (SELECT COUNT(1) FROM mdl_aos_canlender r where d.yearmonth
        =DATE_FORMAT(r.DT_CANDAY,'%Y%m') AND S_CANTYPE in ('1','3') AND r.IS_DELETE=0)
	-SUM(worktimes)-SUM(CASE WHEN datetype='3' THEN 1 ELSE 0 END)
	-(case when date_format(enterdate,'%Y%m')=d.yearmonth
			then (SELECT count(ID) AS count FROM mdl_aos_canlender WHERE S_CANTYPE = 1 AND IS_DELETE = 0
					AND date_format(DT_CANDAY,'%Y%m') =DATE_FORMAT(enterdate,'%Y%m')
					and date_format(DT_CANDAY,'%Y%m')=d.yearmonth
					AND DT_CANDAY < enterdate) else 0 end)
	-(case when leavedate is null or date_format(leavedate,'%Y%m')!=d.yearmonth
			then 0 else (SELECT count(ID) AS count FROM mdl_aos_canlender WHERE S_CANTYPE = 1 AND IS_DELETE = 0 
					AND date_format(DT_CANDAY,'%Y%m') =DATE_FORMAT(leavedate,'%Y%m')
					and date_format(DT_CANDAY,'%Y%m')=d.yearmonth
					AND DT_CANDAY > leavedate) end) DL_DUTY
FROM (
	SELECT 
	DATE_FORMAT(workdate,'%Y%m') yearmonth, DATE_FORMAT(workdate,'%Y') AS S_YEAR,DATE_FORMAT(workdate,'%m') AS S_MONTH,
	username, userid, worktimes, dailytype, datetype, enterdate, leavedate,tsfdate, emptypename, userdeptname, workdate
	from t_snap_daily_workinghours_detail
	where appstatus = 1 
and DATE_FORMAT(workdate,'%Y%m') = @yearmonth
-- {yearmonth}  {S_STAFFNAME} 
) d
join (
	SELECT 
	COUNT(case WHEN  S_CANTYPE in (1,3) then 1 END) S_SHOULDDAY,
	COUNT(case WHEN  S_CANTYPE = 3 then 1 END) S_HOLIDAY
	FROM mdl_aos_canlender
	where IS_DELETE = 0 and DATE_FORMAT(DT_CANDAY,'%Y%m') = @yearmonth
)r
GROUP BY userid,d.yearmonth
 