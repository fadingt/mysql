SELECT
	companyname `财务主体`,
	yearmonth `年月`,
	account `总账科目`,
'人力成本差异' `类型`,
	amt `金额`,
	budgetdeptname `所属部门`,
	fidept `财务编码`
FROM `t_snap_fi_standardcost`
where type = 6