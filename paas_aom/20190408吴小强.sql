	SELECT 
		I_PRONUM,
		DATE_FORMAT(DT_YEARMONTH,'%Y%m') `年月`,
		b.S_PRJNO, b.S_PRJNAME,
		SUM(DL_INCCHGMNY) `当月收入`
	from mdl_aos_ficostvar a
	left join mdl_aos_project b on b.ID = a.I_PRONUM
	where 1=1
		and a.IS_DELETE = 0 and b.IS_DELETE = 0
		and DL_INCCHGMNY <> 0
	GROUP BY I_PRONUM, DT_YEARMONTH
ORDER BY a.DT_YEARMONTH, b.S_PRJNO