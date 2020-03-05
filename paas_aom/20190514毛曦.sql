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
tec.REAL_NAME `客户经理`,
ngoss.getfullorgname(tec.ORG_CODE) `客户经理归属部门`,
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
prplan.*
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
-- left join plf_aos_auth_user tech1 on tech1.ID = cust.S_FIRTECH
-- left join plf_aos_auth_user tech2 on tech2.ID = cust.S_SECTECH
left join plf_aos_auth_user tec on tec.id = buz.OWNER_ID
left join plf_aos_auth_user sale on sale.ID = buz.S_SALEMAN
-- left join mdl_aos_hrorg saleorg on saleorg.S_ORGCODE = sale.ORG_CODE
left join (
		SELECT
			I_PRJID,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK2 else 0 end,0) )`一月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK2 else 0 end,0) )`二月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK2 else 0 end,0) )`三月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK2 else 0 end,0) )`四月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK2 else 0 end,0) )`五月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK2 else 0 end,0) )`六月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK2 else 0 end,0) )`七月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK2 else 0 end,0) )`八月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK2 else 0 end,0) )`九月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK2 else 0 end,0) )`十月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK2 else 0 end,0) )`十一月2级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK2 else 0 end,0) )`十二月2级计划人力`,

			sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK3 else 0 end,0) )`一月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK3 else 0 end,0) )`二月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK3 else 0 end,0) )`三月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK3 else 0 end,0) )`四月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK3 else 0 end,0) )`五月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK3 else 0 end,0) )`六月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK3 else 0 end,0) )`七月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK3 else 0 end,0) )`八月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK3 else 0 end,0) )`九月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK3 else 0 end,0) )`十月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK3 else 0 end,0) )`十一月3级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK3 else 0 end,0) )`十二月3级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK4 else 0 end,0) )`一月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK4 else 0 end,0) )`二月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK4 else 0 end,0) )`三月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK4 else 0 end,0) )`四月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK4 else 0 end,0) )`五月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK4 else 0 end,0) )`六月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK4 else 0 end,0) )`七月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK4 else 0 end,0) )`八月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK4 else 0 end,0) )`九月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK4 else 0 end,0) )`十月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK4 else 0 end,0) )`十一月4级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK4 else 0 end,0) )`十二月4级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK5 else 0 end,0) )`一月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK5 else 0 end,0) )`二月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK5 else 0 end,0) )`三月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK5 else 0 end,0) )`四月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK5 else 0 end,0) )`五月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK5 else 0 end,0) )`六月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK5 else 0 end,0) )`七月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK5 else 0 end,0) )`八月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK5 else 0 end,0) )`九月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK5 else 0 end,0) )`十月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK5 else 0 end,0) )`十一月5级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK5 else 0 end,0) )`十二月5级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK6 else 0 end,0) )`一月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK6 else 0 end,0) )`二月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK6 else 0 end,0) )`三月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK6 else 0 end,0) )`四月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK6 else 0 end,0) )`五月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK6 else 0 end,0) )`六月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK6 else 0 end,0) )`七月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK6 else 0 end,0) )`八月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK6 else 0 end,0) )`九月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK6 else 0 end,0) )`十月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK6 else 0 end,0) )`十一月6级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK6 else 0 end,0) )`十二月6级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK7 else 0 end,0) )`一月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK7 else 0 end,0) )`二月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK7 else 0 end,0) )`三月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK7 else 0 end,0) )`四月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK7 else 0 end,0) )`五月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK7 else 0 end,0) )`六月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK7 else 0 end,0) )`七月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK7 else 0 end,0) )`八月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK7 else 0 end,0) )`九月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK7 else 0 end,0) )`十月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK7 else 0 end,0) )`十一月7级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK7 else 0 end,0) )`十二月7级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK8 else 0 end,0) )`一月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK8 else 0 end,0) )`二月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK8 else 0 end,0) )`三月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK8 else 0 end,0) )`四月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK8 else 0 end,0) )`五月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK8 else 0 end,0) )`六月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK8 else 0 end,0) )`七月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK8 else 0 end,0) )`八月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK8 else 0 end,0) )`九月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK8 else 0 end,0) )`十月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK8 else 0 end,0) )`十一月8级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK8 else 0 end,0) )`十二月8级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK9 else 0 end,0) )`一月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK9 else 0 end,0) )`二月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK9 else 0 end,0) )`三月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK9 else 0 end,0) )`四月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK9 else 0 end,0) )`五月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK9 else 0 end,0) )`六月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK9 else 0 end,0) )`七月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK9 else 0 end,0) )`八月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK9 else 0 end,0) )`九月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK9 else 0 end,0) )`十月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK9 else 0 end,0) )`十一月9级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK9 else 0 end,0) )`十二月9级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK10 else 0 end,0) )`一月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK10 else 0 end,0) )`二月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK10 else 0 end,0) )`三月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK10 else 0 end,0) )`四月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK10 else 0 end,0) )`五月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK10 else 0 end,0) )`六月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK10 else 0 end,0) )`七月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK10 else 0 end,0) )`八月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK10 else 0 end,0) )`九月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK10 else 0 end,0) )`十月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK10 else 0 end,0) )`十一月10级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK10 else 0 end,0) )`十二月10级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK11 else 0 end,0) )`一月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK11 else 0 end,0) )`二月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK11 else 0 end,0) )`三月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK11 else 0 end,0) )`四月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK11 else 0 end,0) )`五月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK11 else 0 end,0) )`六月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK11 else 0 end,0) )`七月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK11 else 0 end,0) )`八月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK11 else 0 end,0) )`九月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK11 else 0 end,0) )`十月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK11 else 0 end,0) )`十一月11级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK11 else 0 end,0) )`十二月11级计划人力`,

				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'01')then I_PRANK12 else 0 end,0) )`一月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'02')then I_PRANK12 else 0 end,0) )`二月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'03')then I_PRANK12 else 0 end,0) )`三月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'04')then I_PRANK12 else 0 end,0) )`四月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'05')then I_PRANK12 else 0 end,0) )`五月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'06')then I_PRANK12 else 0 end,0) )`六月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'07')then I_PRANK12 else 0 end,0) )`七月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'08')then I_PRANK12 else 0 end,0) )`八月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'09')then I_PRANK12 else 0 end,0) )`九月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'10')then I_PRANK12 else 0 end,0) )`十月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'11')then I_PRANK12 else 0 end,0) )`十一月12级计划人力`,
				sum(ifnull(case when S_PYEARMON=CONCAT(year(NOW()),'12')then I_PRANK12 else 0 end,0) )`十二月12级计划人力`
		FROM `mdl_aos_prmonthpl` prplan
		where prplan.is_delete = 0
		GROUP BY I_PRJID
)prplan on prplan.I_PRJID = p.id
WHERE	
	p.IS_DELETE = 0
-- AND P.S_APP
-- AND prplan.`七月3级计划人力` <> 0
-- and p.id =152405