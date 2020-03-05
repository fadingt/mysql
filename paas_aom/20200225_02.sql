SELECT *
from(		
		SELECT 
		S_PRJNO `项目编号`
		from mdl_aos_project p
		left join mdl_aos_sapoinf poinf on p.I_POID = poinf.ID
		left join mdl_aos_sacustinf cust on cust.id = poinf.I_CUSTID
		where p.S_PRJTYPE = 'YY' and p.IS_DELETE = 0 and p.S_PRJSTATUS <> 06
)t1
RIGHT join (
		SELECT
		*
		FROM(
					SELECT `项目编号`, `项目名称`, DATE_FORMAT(`年月日`,'%Y%m') `年月`, `成本`
					from ngoss.`收入动态`
					where YEAR(`年月日`) > 2017 and `成本` <> 0
					union all
					SELECT 
					S_PRJNO `项目编号`, p.S_PRJNAME `项目名称`, 
					t.yearmonth `年月`,
					IFNULL(fycb.amt,0)+IFNULL(rlcb.amt,0) `成本`
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
					where year(DT_STARTTIME)>2017 and p.S_PRJTYPE = 'YY' and p.IS_DELETE = 0 and p.S_PRJSTATUS <> 06
					and (IFNULL(fycb.amt,0)+IFNULL(rlcb.amt,0))<>0
		)x
		GROUP BY x.`项目编号`
)t2 on t1.`项目编号` = t2.`项目编号`
where t1.`项目编号` is null