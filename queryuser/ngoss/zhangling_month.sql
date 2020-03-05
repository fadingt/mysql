SELECT
	a.*,ifnull(f_sbillamt,0) f_sbillamt,
case 
	when sumincome > ifnull(f_sbillamt,0) and sumincomeb >= ifnull(f_sbillamt,0) then income
	when sumincome > ifnull(f_sbillamt,0) and sumincomeb < ifnull(f_sbillamt,0) then sumincome - ifnull(f_sbillamt,0)
	when sumincome <= ifnull(f_sbillamt,0) then 0 end as wpys
from
(
			SELECT
				a.projectid, projectno, projectname, yearmonth, income, 
				(sumincome+IFNULL(c.diss,0)) sumincome, (IFNULL(sumincomeb,0)+IFNULL(c.diss,0)) sumincomeb
			from  `query`.t_zhangling a
			left join	(
					SELECT
						projectid,  diss
					FROM `t_income_initincome2`
			) c on a.projectid = c.projectid
			union all
			SELECT
				projectid, projectno, projectname,'201612' as yearmonth, diss, diss, 0
			FROM `t_income_initincome2`
			where projectid is not null
			GROUP BY projectid
)a
left join (
		SELECT 
				projectid,
				SUM(f_sbillamt) f_sbillamt
		from t_contract_stage_ysf_tian
		WHERE left(f_sbillfpdate,6)> 201612 and left(f_sbillfpdate,6)<=left(NOW(),6)
		GROUP BY projectid
) b on a.projectid = b.projectid

ORDER BY projectid, yearmonth