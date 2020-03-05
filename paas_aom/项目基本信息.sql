SELECT 
p.S_PRJNO `项目编号`,
p.S_PRJNAME `项目名称`,
org2.s_name `一级部门`,
org1.s_name `二级部门`,
ngoss.getfullorgname(p.s_dept) `项目所属部门`,
-- case LENGTH(p.s_dept) when 16 then CONCAT(org2.s_name,'-',org1.s_name,'-',org.s_name) else CONCAT(org2.s_name,'-',org1.s_name) end `项目所属部门`,
prjclass.DICT_NAME `项目分类`,
IDC1.dict_name `解决方案`,
IDC2.dict_name `解决子案2`,
-- cont.contype `项目类型`,
prjstatus.DICT_NAME `项目状态`,
ApproStatus.DICT_NAME `审批状态`,
opertype.DICT_NAME `操作类型`,
PBaseType.DICT_NAME `依据状态`,
incomeway.DICT_NAME `收入确认方式`,
pm.REAL_NAME `项目经理`,
pd.REAL_NAME `项目总监`,
cust.S_CUSTNAME `客户名称`,

sale.REAL_NAME `销售代表`,
saleorg.S_NAME `销售部门`,
case when LENGTH(saleorg.S_ORGCODE) > 13 then (SELECT left(S_NAME,2) from mdl_aos_hrorg where ID = saleorg.S_PRE_ORG) else saleorg.S_NAME end `销售大区`,
tech1.REAL_NAME `客户经理a`,
tech2.REAL_NAME `客户经理b`,
DT_SETUPTIME `项目创建日期`,
p.DT_STARTTIME `项目开始日期`,
p.DT_ENDTIME `项目结束日期`,
p.DT_MAINEND  `项目维保期`,
p.DL_BUDCOAMTI `立项金额`,
costfee.*
from mdl_aos_project p
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'IDC1') IDC1 ON IDC1.dict_code = p.S_IDC1
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'IDC2') IDC2 ON IDC2.dict_code = p.S_IDC2
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjclass') prjclass on prjclass.DICT_CODE = p.S_PRJCLASS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'prjstatus') prjstatus on prjstatus.DICT_CODE = p.S_PRJSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.DICT_CODE = p.S_APPSTATUS
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'OPERTYPE') opertype on opertype.DICT_CODE = p.S_OPERTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'PBaseType') PBaseType on PBaseType.DICT_CODE = p.S_BASEFULL
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'INCOMEWAY') incomeway on incomeway.DICT_CODE = p.S_INCOMEWAY
-- left join mdl_aos_project b on LOCATE(CONCAT(',',b.ID),S_PRIDS) != 0

left join plf_aos_auth_user pm on pm.ID = p.S_MANAGER
left join plf_aos_auth_user pd on pd.ID = p.S_DIRECTOR
left join mdl_aos_hrorg org on org.S_ORGCODE = p.S_DEPT
left join mdl_aos_hrorg org1 on org1.s_orgcode = left(p.s_dept,13)
left join mdl_aos_hrorg org2 on org2.s_orgcode = left(p.s_dept,10)

left join mdl_aos_sapnotify nify on nify.ID = p.I_PRJNOTICE
left join mdl_aos_sapoinf buz on buz.ID = nify.I_POID
left join mdl_aos_sacustinf cust on cust.ID = buz.I_CUSTID
left join plf_aos_auth_user tech1 on tech1.ID = cust.S_FIRTECH
left join plf_aos_auth_user tech2 on tech2.ID = cust.S_SECTECH
left join plf_aos_auth_user sale on sale.ID = cust.S_SALEOWNER
left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = sale.ORG_CODE
left join (
		SELECT
			project.S_PRJNO,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'01')then standardcost else 0 end,0) )`一月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'02')then standardcost else 0 end,0) )`二月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'03')then standardcost else 0 end,0) )`三月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'04')then standardcost else 0 end,0) )`四月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'05')then standardcost else 0 end,0) )`五月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'06')then standardcost else 0 end,0) )`六月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'07')then standardcost else 0 end,0) )`七月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'08')then standardcost else 0 end,0) )`八月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'09')then standardcost else 0 end,0) )`九月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'10')then standardcost else 0 end,0) )`十月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'11')then standardcost else 0 end,0) )`十一月标准成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'12')then standardcost else 0 end,0) )`十二月标准成本`,

				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'01')then realcost else 0 end,0) )`一月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'02')then realcost else 0 end,0) )`二月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'03')then realcost else 0 end,0) )`三月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'04')then realcost else 0 end,0) )`四月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'05')then realcost else 0 end,0) )`五月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'06')then realcost else 0 end,0) )`六月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'07')then realcost else 0 end,0) )`七月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'08')then realcost else 0 end,0) )`八月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'09')then realcost else 0 end,0) )`九月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'10')then realcost else 0 end,0) )`十月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'11')then realcost else 0 end,0) )`十一月实际成本`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'12')then realcost else 0 end,0) )`十二月实际成本`,

				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'01')then realfee else 0 end,0) )`一月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'02')then realfee else 0 end,0) )`二月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'03')then realfee else 0 end,0) )`三月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'04')then realfee else 0 end,0) )`四月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'05')then realfee else 0 end,0) )`五月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'06')then realfee else 0 end,0) )`六月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'07')then realfee else 0 end,0) )`七月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'08')then realfee else 0 end,0) )`八月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'09')then realfee else 0 end,0) )`九月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'10')then realfee else 0 end,0) )`十月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'11')then realfee else 0 end,0) )`十一月实际费用`,
				sum(ifnull(case when t.yearmonth=CONCAT(year(NOW()),'12')then realfee else 0 end,0) )`十二月实际费用`

		from mdl_aos_project project
		join (
			SELECT	DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') yearmonth
			from mdl_aos_canlender where year(DT_CANDAY) = 2019
		)t
		left join (
			SELECT SUM(amt) realcost, yearmonth, budgetno
			FROM `t_snap_fi_standardcost`
			where budgetno like 'yy%' and isactingstd = 0
			and type = 4 -- 实际工资
			GROUP BY budgetno, yearmonth
		)sjcb on sjcb.yearmonth = t.yearmonth and sjcb.budgetno = project.s_prjno
		left join (
			SELECT SUM(amt) standardcost, yearmonth, budgetno
			FROM `t_snap_fi_standardcost`
			where budgetno like 'yy%' and isactingstd = 1
			and type in (1,2,5)-- 标准工资
			GROUP BY budgetno, yearmonth
		)cost on cost.budgetno = project.s_prjno
		left join (
			SELECT SUM(debit) as realfee,CONCAT(`year`,`month`) as yearmonth, budgetno
			from t_snap_fi_voucher
			where 1=1
			and budgetno like 'yy%' and dc = '01'
			GROUP BY budgetno, CONCAT(`year`,`month`)
		)sjfy  on sjfy.budgetno = project.s_prjno and sjfy.yearmonth = t.yearmonth

		where project.IS_DELETE = 0 and project.S_APPSTATUS = 1
		-- and (realfee is not null or realcost is not null)
		GROUP BY project.ID
) costfee on costfee.S_PRJNO = p.s_prjno
WHERE	
	p.IS_DELETE = 0  AND p.S_PRJTYPE = 'YY'  AND p.S_PRJSTATUS <> '01' and p.s_appstatus = 1
-- and p.S_FINACLOSE = 1 -- 未财务关闭