SELECT 
cont.S_CONCODE, cont.S_CONNAME,
null,checkstg.DT_MAINSTART, checkstg.DT_MAINEND,
12*(year(DT_MAINEND)-year(DT_MAINSTART)) + month(DT_MAINEND)-month(DT_MAINSTART)+1 `维保期`,
null,t.yearmonth,
checkstg.DL_CHECKAMT/(12*(year(DT_MAINEND)-year(DT_MAINSTART)) + month(DT_MAINEND)-month(DT_MAINSTART)+1) income,
translatedict('incomeway',checkstg.S_INCOMEWAY)
from mdl_aos_sacont cont
left join mdl_aos_sacheckapp checkapp on checkapp.I_CONID = cont.ID
left join mdl_aos_sacheckstg checkstg on checkstg.I_CKID = checkapp.ID
join (
	SELECT DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') as yearmonth
	from mdl_aos_canlender
	where DATE_FORMAT(DT_CANDAY,'%Y%m') > 201812
) t
where 1=1
and cont.IS_DELETE = 0 and cont.S_CONTYPE = 01
and checkstg.IS_DELETE = 0 and checkstg.S_TYPE = 3
and checkstg.S_IFMAIN = 2 and checkstg.S_INCOMEWAY = 03
and t.yearmonth BETWEEN DATE_FORMAT(checkstg.DT_MAINSTART,'%Y%m') and DATE_FORMAT(checkstg.DT_MAINEND,'%Y%m')
;