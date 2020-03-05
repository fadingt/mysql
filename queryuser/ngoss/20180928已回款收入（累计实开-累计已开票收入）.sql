SELECT *
from (
	SELECT projectid, projectno, sum(sbillamt) b1, sum(billincome) b2
	from `query`.t_zhangling_baseinfo
where SUBSTRING_INDEX(projectno,'-',2) in  ('yy-2017','yy-2018')
	GROUP BY projectid
)x
-- where x.b1 != x.b2
where (x.b1 - x.b2) > 1


SELECT projectid, projectno, yearmonth, income, sumincome,  billincome, sbillamt
from `query`.t_zhangling_baseinfo where projectid = 150726

SELECT SUM(b1) - SUM(b2)
from (
	SELECT projectid, projectno, sum(sbillamt) b1, sum(billincome) b2
	from `query`.t_zhangling_baseinfo
where SUBSTRING_INDEX(projectno,'-',2) in  ('yy-2017','yy-2018')
	GROUP BY projectid
)x
-- where x.b1 != x.b2
where (x.b1 - x.b2) > 1


SELECT *
from (
	SELECT projectid, projectno, sum(sreceamt) b1, sum(receincome) b2
	from `query`.t_zhangling_baseinfo
where SUBSTRING_INDEX(projectno,'-',2) in ('yy-2017','yy-2018')
	GROUP BY projectid
)x
-- where x.b1 != x.b2
where x.b1 - x.b2 >1

SELECT  projectid, projectno, yearmonth, income, sumincome,  receincome, sreceamt
from `query`.t_zhangling_baseinfo where projectid = 150771

SELECT SUM(b1) - SUM(b2)
from (
	SELECT projectid, projectno, sum(sreceamt) b1, sum(receincome) b2
	from `query`.t_zhangling_baseinfo
where SUBSTRING_INDEX(projectno,'-',2) in ('yy-2017','yy-2018')
	GROUP BY projectid
)x
-- where x.b1 != x.b2
where x.b1 - x.b2 >1