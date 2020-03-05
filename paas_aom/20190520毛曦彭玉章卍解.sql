set @rowid := 0;
SELECT 
@rowid := 1 + @rowid `序号`,
p.S_PRJNO `项目编号`,
p.S_PRJNAME `项目名称`,
prjstatus.DICT_NAME `项目状态`,
opertype.DICT_NAME `操作类型`,
ApproStatus.DICT_NAME `审批状态`,
prjclass.DICT_NAME `项目分类`,
-- '预计合同分类'
cust.S_CUSTNAME `客户名称`,
ngoss.getcompanyname((SELECT I_FINANCEID from mdl_aos_sapoinf where ID = issigned.I_POID)) `项目所属公司`,
-- org2.s_name `一级部门`,
-- org1.s_name `二级部门`,
ngoss.getfullorgname(p.s_dept) `项目所属部门`,
-- case LENGTH(p.s_dept) when 16 then CONCAT(org2.s_name,'-',org1.s_name,'-',org.s_name) else CONCAT(org2.s_name,'-',org1.s_name) end `项目所属部门`,

sale.REAL_NAME `销售代表`,
ngoss.getfullorgname(sale.ORG_CODE) `销售归属部门`,
tech1.REAL_NAME `客户经理`,
ngoss.getfullorgname(tech1.ORG_CODE) `客户经理归属部门`,
-- tech2.REAL_NAME `客户经理b`,
pm.REAL_NAME `项目经理`,
ngoss.getfullorgname(pm.ORG_CODE) `项目经理归属部门`,
pd.REAL_NAME `项目总监`,
ngoss.getfullorgname(pd.ORG_CODE) `项目总监归属部门`,
-- IDC1.dict_name `解决方案`,
-- IDC2.dict_name `解决子案2`,
-- cont.contype `项目类型`,


-- PBaseType.DICT_NAME `依据状态`,
-- incomeway.DICT_NAME `收入确认方式`,
-- DT_SETUPTIME `项目创建日期`,
DATE_FORMAT(p.DT_STARTTIME,'%Y%m%d') `项目开始日期`,
DATE_FORMAT(p.DT_ENDTIME,'%Y%m%d') `项目结束日期`,
DATE_FORMAT(p.DT_MAINEND,'%Y%m%d')  `项目维护结束日期`,
T_ADDRESS `项目地点`, 
T_PRJDESC `项目描述`,
case issigned.cnt when 0 then '否' else '是' end `是否签约`,
p.DL_BUDCOAMTI `立项金额`,
p.DL_BUDLABAMT `预算人力成本`,
p.I_BUDLABDAY `预算人天总数`,
prplan.rank `级别`,
prplan.yearmonth `年月`,
prplan.prl `人天`
from mdl_aos_project p
left join (
	SELECT COUNT(a.DT_FILEDATE) cnt, b.ID, b.I_POID
	from mdl_aos_sacont a, mdl_aos_sapnotify b
	where 1=1
	and a.IS_DELETE = 0 and b.IS_DELETE = 0
	and a.I_POID = b.I_POID
	GROUP BY b.ID
) issigned on issigned.ID = p.I_PRJNOTICE
-- left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'IDC1') IDC1 ON IDC1.dict_code = p.S_IDC1
-- left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'IDC2') IDC2 ON IDC2.dict_code = p.S_IDC2
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
-- left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = sale.ORG_CODE
left join (
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 2 as rank, SUM(I_PRANK2) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 3 as rank, SUM(I_PRANK3) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 4 as rank, SUM(I_PRANK4) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 5 as rank, SUM(I_PRANK5) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 6 as rank, SUM(I_PRANK6) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 7 as rank, SUM(I_PRANK7) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 8 as rank, SUM(I_PRANK8) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 9 as rank, SUM(I_PRANK9) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 10 as rank, SUM(I_PRANK10) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 11 as rank, SUM(I_PRANK11) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
union all
		SELECT
			I_PRJID, S_PYEARMON as yearmonth, 12 as rank, SUM(I_PRANK12) prl-- 计划人力
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID, S_PYEARMON
)prplan on prplan.I_PRJID = p.id
WHERE	
	p.IS_DELETE = 0