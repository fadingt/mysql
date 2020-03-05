/**/
SELECT `项目编号`, `项目名称`, DATE_FORMAT(`年月日`,'%Y%m') `年月`, 
if(`成本`='',0,`成本`) `成本`, 
if(`实开`='',0,`实开`) `实开`, 
if(`实回`='',0,`实回`) `实回`
from ngoss.`收入动态`
where YEAR(`年月日`) > 2017  and SUBSTRING(`项目编号` FROM 4 FOR 4) BETWEEN 2018 and 2019
union all

SELECT 
S_PRJNO `项目编号`, p.S_PRJNAME `项目名称`, 
t.yearmonth `年月`,
IFNULL(fycb.amt,0)+IFNULL(rlcb.amt,0) `成本`, IFNULL(sbill.sbillamt,0) `实开`, IFNULL(sback.sbackamt,0) `实回`
from mdl_aos_project p

join (
	SELECT DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') yearmonth from mdl_aos_canlender 
	where year(DT_CANDAY) BETWEEN 2019 and 2020 and IS_DELETE = 0 
) t on t.yearmonth BETWEEN DATE_FORMAT(p.DT_STARTTIME,'%Y%m') and DATE_FORMAT(p.DT_MAINEND,'%Y%m')

left join (
		SELECT SUM(debit) amt, budgetno, yearmonth
		from paas_aom.t_snap_fi_voucher
		where dc = '01' and yearmonth is not null and busitype not in (22002,27001,23002,24002) and zzno = '6401'
		GROUP BY budgetno, yearmonth
)fycb on p.S_PRJNO = fycb.budgetno and fycb.yearmonth = t.yearmonth
left join (
		SELECT SUM(amt) amt, budgetno, yearmonth
		FROM paas_aom.t_snap_fi_standardcost
		where isactingstd = 1 and budgetno is not null and type in (1,2)
		GROUP BY budgetno, yearmonth
)rlcb on p.S_PRJNO = rlcb.budgetno and rlcb.yearmonth = t.yearmonth
left join (
	select S_PJNO, DATE_FORMAT(DT_PRABILLDT,'%Y%m') sbilldate, SUM(DL_PRABILLAT) sbillamt
	from mdl_aos_evidence a
	join (SELECT MAX(S_VERSION) max_version from mdl_aos_evidence where IS_DELETE = 0) b on a.S_VERSION = b.max_version
	where a.IS_DELETE = 0 and a.S_OPERTYPE <> '004' and a.DT_ACTBILLDT is not null
	GROUP BY a.S_PJNO, DATE_FORMAT(a.DT_ACTBILLDT,'%Y%m')
)sbill on p.s_prjno = sbill.s_pjno and t.yearmonth = sbill.sbilldate
left join (
	select S_PJNO, DATE_FORMAT(DT_PRABACKDT,'%Y%m') sbackdate, SUM(DL_PRABACKAT) sbackamt
	from mdl_aos_evidence a
	join (SELECT MAX(S_VERSION) max_version from mdl_aos_evidence where IS_DELETE = 0) b on a.S_VERSION = b.max_version
	where a.IS_DELETE = 0 and a.S_OPERTYPE <> '004' and a.DT_ACTBACKDT is not null
	GROUP BY a.S_PJNO, DATE_FORMAT(a.DT_ACTBACKDT,'%Y%m')
)sback on p.S_PRJNO = sback.S_PJNO and t.yearmonth = sback.sbackdate
where p.S_PRJTYPE = 'YY' and p.IS_DELETE = 0 and p.S_PRJSTATUS <> 06
and SUBSTRING(p.S_PRJNO FROM 4 FOR 4) BETWEEN 2018 and 2019