SELECT
	SUM(sjfy)
FROM
(
			SELECT
			projectid,
			projectno,
			projectname,
			deptid,
			translatedict ('IDFS000070', projstatus) projstatusname,
			IFNULL(translatedict ('IDFS000091', projecttype),'') projecttypename,
			IFNULL(translatedict ('IDFS000092', businesstype),'') businesstypename,
			SUM(fee) fee,-- 预计费用
			SUM(cost) cost,-- 预计成本
			SUM(yjcb_cg) yjcb_cg, -- 预计采购
			SUM(jan_sjcb+feb_sjcb+mar_sjcb) sjcb,-- 一季度实际成本
			sum(jan_sjfy+feb_sjfy+mar_sjfy) sjfy,-- 一季度实际费用
			SUM(jan_cgcb+feb_cgcb+mar_cgcb) cgcb -- 一季度采购成本
-- 			SUM(realcost) sjcb, -- 实际成本
-- 			SUM(realfee) sjfy, -- 实际费用
-- 			sum(purchasecost) cg-- 实际采购
		from t_report_projectinfoinout
		where nowyear = 2018 and SUBSTRING_INDEX(projectno,'-',1)='YF'
		GROUP BY projectid
)x