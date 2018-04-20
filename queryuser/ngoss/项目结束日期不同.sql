SELECT 
a.projectid, a.projectno,
	translatedict ('IDFS000070', b.projstatus)  projstatusname,
a.startdate,
b.predictstartdate,
a.enddate,
b.predictenddate 
from 
(
		SELECT * 
		from t_income_prjmonthincome_fi 
		WHERE yearmonth =201801
) a
join t_project_projectinfo b on a.projectid = b.projectid
where a.startdate != b.predictstartdate or a.enddate != b.predictenddate