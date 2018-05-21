-- 查询本部门的合同分配项目明细表 contract_main_pro_br
select * from (
SELECT
	ysf.*,
	project.projectno, project.projectname, project.deptid deptidp,
	getcustname(contract.firstparty) custname,  contract.deptid
FROM(
	select 	-- 历史数据
		contractid, projectid,
		contractno,contractname,id,orderid,pono,type,typename,stagename stagedescription,
		ybilldate,ybillamt,yrecedate,yreceamt,sbilldate,srecedate,ifnull(sbillamt,0) sbillamt,ifnull(sreceamt,0) sreceamt,
		ifnull(f_sbillamt,0) sallocatebillamt,	ifnull(f_sreceamt,0) sallocatepayamt,	ifnull(f_ybillamt,0) allocatebillamt,	ifnull(f_yreceamt,0) allocatepayamt,
		f_fpperson,f_fpdate,insertdate -- 预计分配人 分配日期 快照日期
	from t_contract_stage_ysf_tian_his
	union all
	select 	-- 当天数据
		contractid, projectid,
		contractno,contractname,id,orderid,pono,type,typename,stagename stagedescription,
		ybilldate,ybillamt,yrecedate,yreceamt,sbilldate,srecedate,ifnull(sbillamt,0) sbillamt,ifnull(sreceamt,0) sreceamt,
		ifnull(f_sbillamt,0) sallocatebillamt,	ifnull(f_sreceamt,0) sallocatepayamt,	ifnull(f_ybillamt,0) allocatebillamt,	ifnull(f_yreceamt,0) allocatepayamt,
		f_fpperson,f_fpdate,insertdate
	from t_contract_stage_ysf_tian
) ysf
left join t_project_projectinfo project on ysf.projectid = project.projectid
left join t_contract_main contract on ysf.contractid = contract.contractid
) x
where 1=1 
-- and deptidp in (:roledatascope)
-- {contractno}
-- {contractname}
-- {custname}
