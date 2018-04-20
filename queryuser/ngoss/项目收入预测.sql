BEGIN
  -- 项目预测未来6个月的成本，收入（定时跑批）
  -- author mahao
  DECLARE c_yearmonth1 VARCHAR(12);-- M+1月份 201803
  DECLARE c_yearmonth2 VARCHAR(12);
  DECLARE c_yearmonth3 VARCHAR(12);
  DECLARE c_yearmonth4 VARCHAR(12);
  DECLARE c_yearmonth5 VARCHAR(12);
  DECLARE c_yearmonth6 VARCHAR(12);-- M+6月份 

  DECLARE c_cost1 decimal(12,2);-- 预测M+1成本
  DECLARE c_cost2 decimal(12,2);-- 预测M+2成本
  DECLARE c_cost3 decimal(12,2);-- 预测M+3成本
  DECLARE c_cost4 decimal(12,2);-- 预测M+4成本
  DECLARE c_cost5 decimal(12,2);-- 预测M+5成本
  DECLARE c_cost6 decimal(12,2);-- 预测M+6成本
  DECLARE c_income1 decimal(12,2) -- 预测T+1收入
  DECLARE c_income2 decimal(12,2) -- 预测T+2收入
  DECLARE c_income3 decimal(12,2) -- 预测T+3收入
  DECLARE c_income4 decimal(12,2) -- 预测T+4收入
  DECLARE c_income5 decimal(12,2) -- 预测T+5收入
  DECLARE c_income6 decimal(12,2) -- 预测T+6收入


  DECLARE c_nowdate VARCHAR(12);-- 获取当前时间  201803

  DECLARE c_tmpdate VARCHAR(12);-- 临界点日期  201808

  DECLARE projectno VARCHAR(12); -- 项目编号
   
  DECLARE projectname VARCHAR(12); -- 项目名称

  DECLARE projecttype VARCHAR(12);-- 项目类型
  
  -- 项目开始日期 项目结束日期 项目维护周期 项目预算收入 项目预算成本（人力成本+费用+内外采购），内外采购费用 项目累计确认收入 累计项目成本 累计采购费用  M+1（人力成本），M+2,M+3,M+4,M+5,M+6，M+1（预计费用），M+2,M+3,M+4,M+5,M+6 
  DECLARE prj_starttime VARCHAR(12); -- 项目开始日期
  
  DECLARE prj_endtime VARCHAR(12); -- 项目结束日期

  DECLARE prj_prevendtime VARCHAR(12); -- 项目维护结束日期

  DECLARE prj_worktime int; -- 项目周期

  DECLARE prj_preventime int; -- 维护周期

  DECLARE Prj_purchase_cost decimal(12,2); -- 累计采购成本

  DECLARE Prj_Total_cost decimal(12,2); -- 累计成本
  
  Declare Prj_Total_Income decimal(12,2); -- 累计确认收入
  
  DECLARE Prj_cgfy decimal(12,2); -- 项目采购费用

  DECLARE Prj_predictincome decimal(12,2); -- 项目预算收入

  DECLARE Prj_predictcost decimal(12,2); -- 项目预算成本
  
    -- 遍历数据结束标志
 DECLARE done INT DEFAULT FALSE;


   -- 查询项目数据视图游标
  DECLARE a_projectinfo CURSOR FOR select	
projectno,
projectname,
businesstype,
  predictstartdate, -- '预计开始日期',
  predictenddate, -- '预计结束日期',
  maintenancedate, -- '维护结束日期'
  CEIL((DATEDIFF(predictenddate,predictstartdate)/30)) as prjworktime,-- 项目周期
  CEIL((DATEDIFF(maintenancedate,predictenddate)/30)) as prj, -- 维护周期
  sum(jan_cgcb+feb_cgcb+mar_cgcb+apr_cgcb+may_cgcb+jun_cgcb+jul_cgcb+aug_cgcb+sep_cgcb+oct_cgcb+nov_cgcb+dec_cgcb) as T_purchase_cost,-- 累计采购成本
	sum(jan_sjcb+feb_sjcb+mar_sjcb+apr_sjcb+may_sjcb+jun_sjcb+jul_sjcb+aug_sjcb+sep_sjcb+oct_sjcb+nov_sjcb+dec_sjcb) as T_cost,-- 累计成本(人力+费用+内外采）
	sum(jan_sjsr+feb_sjsr+mar_sjsr+apr_sjsr+may_sjsr+jun_sjsr+jul_sjsr+aug_sjsr+sep_sjsr+oct_sjsr+nov_sjsr+dec_sjsr) as T_income,-- 累计确认收入
	sum(yjcb_cg) as cgfy,  -- 内外采购费用
  predictincome, -- 项目预算收入
  predictcost-- 项目预算成本
from t_report_projectinfoinout t
GROUP BY projectno;
      -- 将结束标志绑定到游标
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN a_projectinfo;  -- 打开游标
 -- OPEN a_implementation;  -- 打开游标
       -- 开始循环
  loop_label:LOOP 
   -- 提取游标里的数据
  fetch a_projectinfo into projectno,projectname,projecttype,prj_starttime,prj_endtime,prj_prevendtime,prj_worktime,prj_preventime,Prj_purchase_cost,Prj_Total_cost,Prj_Total_Income,Prj_cgfy,Prj_predictincome,Prj_predictcost;
  -- 声明结束的时候
  IF done THEN
  LEAVE loop_label;
   END IF;
    -- 这里做你想做的循环的事件
--     IF(projecttype==1||projecttype==3||projecttype==11||projecttype==12) THEN
    
    ELSEIF (projecttype=7) THEN
			set c_cost1 = 0;set c_cost2 = 0;set c_cost3 = 0;set c_cost4 = 0;set c_cost5 = 0;set c_cost6 = 0;
			set c_income1 = 0;set c_income2 = 0;set c_income3 = 0;set c_income4 = 0;set c_income5 = 0;set c_income6 = 0;
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_1 ) then set c_cost1 = T_cost 
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_2 ) then set c_cost1 = T_cost
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_3 ) then set c_cost1 = T_cost
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_4 ) then set c_cost1 = T_cost
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_5 ) then set c_cost1 = T_cost
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_6 ) then set c_cost1 = T_cost

			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_1 ) then set c_income1 = T_income
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_2 ) then set c_income2 = T_income
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_3 ) then set c_income3 = T_income
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_4 ) then set c_income4 = T_income
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_5 ) then set c_income5 = T_income
			IF(DATE_FORMAT(predictenddate,'%Y%m') == M_6 ) then set c_income6 = T_income
		UPDATE test
			set cost1=c_cost1, cost2=c_cost2, cost3=c_cost3, cost4=c_cost4, cost5=c_cost5, cost6=c_cost6,
					income1=c_income1, income2=c_income2, income3=c_income3, income4=c_income4, income5=c_income5, income6=c_income6,
					t_projectno=projectno
    END LOOP loop_label;
  -- 关闭游标
 CLOSE a_projectinfo;
 SET done = FALSE;
END