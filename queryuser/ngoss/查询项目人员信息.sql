SELECT
	*	
FROM 
(
	SELECT
		projectid,
		userid,
		username,
		salepricelevel,
		salepriceleveltext,
		begintime,-- 进项时间
		endtime,-- 出项时间
		predictpsdays -- 预计投入人天
	FROM `t_project_projectperson` t
) x

join  
(
	SELECT 
		projectid projectid1, 
		projectno, projectname,
		translatedict('IDFS000091', projecttype),
		translatedict('IDFS000092', businesstype),
		predictstartdate predictstartdate1, predictenddate predictenddate1, maintenancedate maintenancedate1,
		b.custname,
		getusername(b.tecpersonid) techperson,-- 客户经理/项目技术负责人
		getusername(saleid) salename,
		SUBSTRING_INDEX(translateseconddict('JSLY',technologyarea,technologyarea2),'-', 1) techarea1, -- 解决方案
		SUBSTRING_INDEX(translateseconddict('JSLY',technologyarea,technologyarea2),'-', -1) techarea2 -- 解决方案子类
	from
		`t_project_projectinfo` a,
		`t_sale_custbasicdata` b
	where 
		a.finalcustomer = b.custid
		and projstatus in (1,2)
-- and businesstype in (4,10)
-- and projectid = 31361
) x1 on x.projectid = x1.projectid1

LEFT JOIN
(
	SELECT
		projectid projectid2,
		employeelevel,-- translatedict('IDFS000341',employeelevel),
		saleprice,
		salepricetype
	FROM t_project_levelsaleprice
) x2 on x2.projectid2 = x.projectid and x2.employeelevel = x.salepriceleveltext

GROUP BY projectid, userid
ORDER BY projectid