SELECT 
	ps.I_POID `项目商机ID`, po.S_POCODE `项目商机编号`,	po.S_PONAME `项目商机名称`,
	ps.ID `售前ID`,	ps.s_prescode `售前编号`,	ps.S_PRESNAME `售前名称`,
	CONCAT(psapptype.dict_name, '-', prestype.DICT_NAME) `售前分类`,
	ps.DT_BEGDATE `开始日期`, ps.DT_ENDDATE `结束日期`,
	IFNULL(ps.DL_PRESUMFEE,0) + IFNULL(ps.DL_SUMAMT,0) `总额`,
	ps.DL_PRESUMFEE `预计费用总额`,
	ps.DL_SUMAMT `预计人天总额`,
	ngoss.getusername(ps.OWNER_ID) `售前预算建立人`,
	ngoss.getfullorgname(sale.ORG_CODE) `销售归属部门`,
	sjcb.realcost `实际人力成本`, sjfy.realfee `实际费用`
FROM mdl_aos_sapoinf po
left JOIN MDL_AOS_SAPOPSAPP ps  on ps.I_POID = po.ID
left join plf_aos_auth_user sale on sale.ID = ps.S_SALEMAN
left join (SELECT * from plf_aos_dictionary prestype where DICT_TYPE = 'prestype')prestype on prestype.dict_code = ps.S_PRESTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'postatus') postatus on postatus.dict_code = po.S_POSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') appstatus on appstatus.dict_code = ps.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'psapptype') psapptype on psapptype.dict_code = ps.S_OPERTYPE
left join (
		SELECT SUM(amt) realcost, budgetno
		FROM `t_snap_fi_standardcost`
		where budgetno like 'sq%' and isactingstd = 1
		and type = 4 -- 实际工资
		GROUP BY budgetno
)sjcb on sjcb.budgetno = ps.s_prescode
left join (
		SELECT SUM(debit) as realfee, budgetno
		from t_snap_fi_voucher
		where 1=1
		and budgetno like 'sq%' and dc = '01'
		GROUP BY budgetno
)sjfy ON sjfy.budgetno = ps.s_prescode
where ps.S_APPSTATUS = 1 and ps.IS_DELETE = 0