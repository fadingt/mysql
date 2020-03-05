	SELECT 
		a.*,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost1 + b.sumfigure1)/(a.sumcost+a.sumfigure)
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth1,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome1,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost2 + b.sumfigure2)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth2,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome2,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost3 + b.sumfigure3)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth3,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome3,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost4 + b.sumfigure4)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth4,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome4,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost5 + b.sumfigure5)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth5,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome5,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost6 + b.sumfigure6)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth6,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome6,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost7 + b.sumfigure7)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth7,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome7,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost8 + b.sumfigure8)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth8,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome8,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost9 + b.sumfigure9)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth9,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome9,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost10 + b.sumfigure10)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth10,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome10,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost11 + b.sumfigure11)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth11,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome11,
		case 
			when a.ismonthplan = 1 and (a.sumcost+a.sumfigure) <> 0 then a.bizincome*(b.sumcost12 + b.sumfigure12)/(a.sumcost+a.sumfigure) 
			when (a.ismonthplan = 0 or (a.sumcost+a.sumfigure) = 0) and (CONCAT(c.yearmonth12,'15') BETWEEN DATE_FORMAT(a.predictstartdate,'%Y%m%d') and DATE_FORMAT(DATE_SUB(a.predictenddate,INTERVAL 1 DAY),'%Y%m%d') then a.bizincome/a.workmonth
			else 0
		end as preincome12
	FROM(
		select
				a.oppid, oppmainno, oppname, year boyear,
				predictstartdate,predictenddate, ngoss.getMonthNum(predictstartdate, predictenddate) workmonth,
				predicttotalprice,-- 项目商机金额
				(predicttotalprice*0.9/1.06) bizincome,-- 项目商机收入
				b.sumcost, b.sumfigure,
				case when b.oppid is not null then 1 when b.oppid is null then 0 end as ismonthplan -- 是否有人月计划 1 有 0 没有
		from ngoss.t_sale_businessopportunity a
		left join(
				SELECT
					oppid, sum(sumcost) sumcost, SUM(sumfigure) sumfigure
				from ngoss.t_sale_monthbudget
				group by oppid
		) b on a.oppid = b.oppid
		WHERE a.`status` in (2,3)
and a.oppstep != 6 
and year = 2018
	) a
	left join (
			SELECT
				oppid,
				SUM(case when yearmonth = yearmonth1 then sumcost else 0 end) sumcost1,
				SUM(case when yearmonth = yearmonth2 then sumcost else 0 end) sumcost2,
				SUM(case when yearmonth = yearmonth3 then sumcost else 0 end) sumcost3,
				SUM(case when yearmonth = yearmonth4 then sumcost else 0 end) sumcost4,
				SUM(case when yearmonth = yearmonth5 then sumcost else 0 end) sumcost5,
				SUM(case when yearmonth = yearmonth6 then sumcost else 0 end) sumcost6,
				SUM(case when yearmonth = yearmonth7 then sumcost else 0 end) sumcost7,
				SUM(case when yearmonth = yearmonth8 then sumcost else 0 end) sumcost8,
				SUM(case when yearmonth = yearmonth9 then sumcost else 0 end) sumcost9,
				SUM(case when yearmonth = yearmonth10 then sumcost else 0 end) sumcost10,
				SUM(case when yearmonth = yearmonth11 then sumcost else 0 end) sumcost11,
				SUM(case when yearmonth = yearmonth12 then sumcost else 0 end) sumcost12,
				SUM(case when yearmonth = yearmonth1 then sumfigure else 0 end) sumfigure1,
				SUM(case when yearmonth = yearmonth2 then sumfigure else 0 end) sumfigure2,
				SUM(case when yearmonth = yearmonth3 then sumfigure else 0 end) sumfigure3,
				SUM(case when yearmonth = yearmonth4 then sumfigure else 0 end) sumfigure4,
				SUM(case when yearmonth = yearmonth5 then sumfigure else 0 end) sumfigure5,
				SUM(case when yearmonth = yearmonth6 then sumfigure else 0 end) sumfigure6,
				SUM(case when yearmonth = yearmonth7 then sumfigure else 0 end) sumfigure7,
				SUM(case when yearmonth = yearmonth8 then sumfigure else 0 end) sumfigure8,
				SUM(case when yearmonth = yearmonth9 then sumfigure else 0 end) sumfigure9,
				SUM(case when yearmonth = yearmonth10 then sumfigure else 0 end) sumfigure10,
				SUM(case when yearmonth = yearmonth11 then sumfigure else 0 end) sumfigure11,
				SUM(case when yearmonth = yearmonth12 then sumfigure else 0 end) sumfigure12
			from ngoss.t_sale_monthbudget a
			join(
				SELECT 
					DATE_FORMAT(NOW(), '%Y%m') as yearmonth1, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 1 MONTH), '%Y%m') as yearmonth2,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 2 MONTH), '%Y%m') as yearmonth3, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 3 MONTH), '%Y%m') as yearmonth4,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 4 MONTH), '%Y%m') as yearmonth5, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 5 MONTH), '%Y%m') as yearmonth6,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 6 MONTH), '%Y%m') as yearmonth7, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 7 MONTH), '%Y%m') as yearmonth8,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 8 MONTH), '%Y%m') as yearmonth9, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 9 MONTH), '%Y%m') as yearmonth10,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 10 MONTH), '%Y%m') as yearmonth11, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 11 MONTH), '%Y%m') as yearmonth12
				from dual
			) b
			GROUP BY oppid
	) b on a.oppid = b.oppid
	join(
		SELECT 
					DATE_FORMAT(NOW(), '%Y%m') as yearmonth1, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 1 MONTH), '%Y%m') as yearmonth2,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 2 MONTH), '%Y%m') as yearmonth3, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 3 MONTH), '%Y%m') as yearmonth4,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 4 MONTH), '%Y%m') as yearmonth5, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 5 MONTH), '%Y%m') as yearmonth6,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 6 MONTH), '%Y%m') as yearmonth7, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 7 MONTH), '%Y%m') as yearmonth8,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 8 MONTH), '%Y%m') as yearmonth9, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 9 MONTH), '%Y%m') as yearmonth10,
					DATE_FORMAT(ADDDATE(NOW(),INTERVAL 10 MONTH), '%Y%m') as yearmonth11, DATE_FORMAT(ADDDATE(NOW(),INTERVAL 11 MONTH), '%Y%m') as yearmonth12
		from dual
	) c
-- WHERE a.ismonthplan = 1
-- WHERE oppmainno like 'YY-2018-0552-04'