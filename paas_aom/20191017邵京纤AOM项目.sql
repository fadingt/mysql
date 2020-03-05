SELECT
project.S_PRJNO `项目编号`,
project.S_PRJNAME `项目名称`,
cust.S_CUSTNAME `客户名称`,
-- project.S_DEPT `项目所属部门`,
case LENGTH(project.S_DEPT) 
when 10 then org1.s_name 
when 13 then CONCAT(org1.s_name,'-',org2.s_name)
when 16 then CONCAT(org1.s_name,'-',org2.s_name,'-', org3.s_name) END `项目所属部门`,
(SELECT dict_name from plf_aos_dictionary where DICT_CODE = S_IDC1 and DICT_TYPE = 'IDC1') `解决方案`, 
(SELECT dict_name from plf_aos_dictionary where DICT_CODE = S_IDC2 and DICT_TYPE = 'IDC2') `解决子案2`,
null `项目大类`,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJCLASS' and DICT_CODE = project.S_PRJCLASS) `项目类型-新`,
DATE_FORMAT(project.DT_STARTTIME,'%Y/%m/%d') AS `开始日期`,
DATE_FORMAT(project.DT_ENDTIME,'%Y/%m/%d') AS `结束日期`,
DATE_FORMAT(project.DT_MAINEND,'%Y/%m/%d') AS `维护日期`,
comp.S_COMPNAME `财务主体`,
sale.REAL_NAME `所属销售`,
salearea.S_NAME `销售区域`,
null `项目会计`,
tec.REAL_NAME `客户经理`,
tecarea.S_NAME `客户经理部门`,

(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'PRJSTATUS' and DICT_CODE = project.S_PRJSTATUS) `项目状态`,
null `OA收入确认方式`,
null `会计认定收入确认方式`,
project.DL_BUDCOAMTI `预算合同额`,
project.DL_NINCOME `预算收入`,
project.DL_BUDTOLCOS `预算总成本`,

monthplan.`预计人天`,
monthplan.`2019年期初人天`,
monthplan.`2019年发生人天`,
monthplan.`已发生人天`,
monthplan.`已发生人天成本`,
monthplan.`将投入人天`,
qc.`2019期初成本`,
IFNULL(sjfy.realfee,0) `AOM已发生费用`,
IFNULL(Purchase.realpur,0) `AOM已发生采购`,
IFNULL(monthplan.`AOM已发生人天成本`,0) `AOM已发生人天`,
null,null
from mdl_aos_project project
left join mdl_aos_sapnotify note on note.id = project.I_PRJNOTICE
left join mdl_aos_sapoinf poinf on note.I_POID = poinf.ID
left join mdl_aos_sacustinf cust on cust.ID = poinf.I_CUSTID
left join (
		SELECT
			x.I_PRJID,
			SUM(CASE WHEN !x.flag and left(x.S_PYEARMON,4) < 2019 then x.scost else 0 END) `2019年期初人天`,
			SUM(CASE WHEN !x.flag and left(x.S_PYEARMON,4) = 2019 then x.scost else 0 END) `2019年发生人天`,
			SUM(case when !x.flag and left(x.S_PYEARMON,4) > 2018 then x.scost else 0 end) `AOM已发生人天成本`,
			SUM(case when !x.flag then x.sworkdays else x.yworkdays END) `预计人天`,
			SUM(case when !x.flag then x.sworkdays else 0 END) `已发生人天`,
			SUM(case when !x.flag then x.scost else 0 end) `已发生人天成本`,
			SUM(case when x.flag then x.yworkdays else 0 end)`将投入人天`
		FROM (
				SELECT 
					SUM(I_PLABTLDAY) yworkdays,-- `预计报工数`,
					SUM(DL_PLABTLFEE) ycost,-- `预计报工成本`,
					SUM(I_RLABHOUR/8) sworkdays,-- `实际报工数`,
					SUM(DL_RLABTLFEE) scost,-- `实际报工成本`,
					I_PRJID, S_PYEARMON, S_PYEARMON>b.yearmonth flag
				from mdl_aos_prmonthpl a
				join (SELECT MAX(S_PYEARMON) yearmonth from mdl_aos_prmonthpl where IS_DELETE = 0 and DL_RLABTLFEE <> 0)b
				where IS_DELETE = 0
				GROUP BY I_PRJID, S_PYEARMON
		)x
		GROUP BY x.I_PRJID
)monthplan on monthplan.I_PRJID = project.ID
		left join (
			SELECT SUM(debit) as realfee, budgetno
			from paas_aom.t_snap_fi_voucher
			where yearmonth is not null  and dc = '01' 
			and budgetno is not null and zzno = '6401' 
			and busitype not in (22002,27001,23002,24002)
			and mxno not in (640133,640134)
			GROUP BY budgetno
		)sjfy  on sjfy.budgetno = project.s_prjno
		left join (
			SELECT SUM(debit) as realpur, budgetno
			from paas_aom.t_snap_fi_voucher
			where dc = '01'
			and yearmonth is not null
			and busitype not in (22002,27001,23002,24002)
			and mxno in (140501,140502,14050333,14050334,640133,640134)
			GROUP BY budgetno
		)Purchase on Purchase.budgetno = project.s_prjno
left join (
	SELECT
		projectno,cumulativecost `2019期初成本`
	FROM t_snap_income_projectinfo
	WHERE yearmonth = '201812'
)qc on qc.projectno = project.S_PRJNO
left join plf_aos_auth_user tec on tec.id = poinf.OWNER_ID
left join plf_aos_auth_user sale on sale.id = poinf.S_SALEMAN
left join mdl_aos_hrorg salearea on sale.ORG_CODE = salearea.S_ORGCODE
left join mdl_aos_hrorg tecarea on tec.ORG_CODE = tecarea.S_ORGCODE
left join mdl_aos_compcode comp on comp.ID = poinf.I_FINANCEID
left join mdl_aos_hrorg org1 on left(project.s_dept,10) = org1.s_orgcode
left join mdl_aos_hrorg org2 on left(project.s_dept,13) = org2.s_orgcode
left join mdl_aos_hrorg org3 on left(project.s_dept,16) = org3.s_orgcode

where project.IS_DELETE = 0 and project.S_PRJTYPE = 'YY'