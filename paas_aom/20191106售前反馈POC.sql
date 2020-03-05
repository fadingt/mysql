SELECT 
	ps.ID `售前申请ID`, ps.I_POID `项目商机ID`,
	ps.s_prescode `售前编号`, ps.S_PRESNAME `售前名称`,
	po.S_POCODE `项目商机编号`,	po.S_PONAME `项目商机名称`, cust.S_CUSTNAME `客户名称`,
	prestype.dict_name `售前分类`, 
	SFB.*,
	CONCAT(psapptype.dict_name, '-', prestype.DICT_NAME) `预算类型`,
	IFNULL(ps.DL_PRESUMFEE,0) + IFNULL(ps.DL_SUMAMT,0) `总额`,
	ps.DL_PRESUMFEE `预计费用总额`, ps.DL_SUMAMT `预计人天总额`,

	u.REAL_NAME,
	DATE_FORMAT(ps.DT_BEGDATE, '%Y-%m-%d') `开始日期`,
	DATE_FORMAT(ps.DT_ENDDATE, '%Y-%m-%d') `结束日期`,
	ps.CREATE_TIME `创建日期`, ps.DL_SUMDAYS `预计人天`
from MDL_AOS_SAPOPSAPP ps
left join (
	SELECT 
		a.ID, I_PRESALEID, a.CREATE_TIME `反馈时间`, S_PSFBCODE `售前反馈编码`,
		S_FBSTATUS	`反馈状态`, S_APPSTATUS	`审批状态`,
		b.S_OPERASYS `操作系统`, c.S_DATABASE `数据库类型`, S_COMPANY	`POC参与公司`,
		d.`POC-对接信息`, S_POCATTDES	`POC-附件说明`,
		null `竞争对手`
	from MDL_AOS_SAPOPSFB a
	left join MDL_AOS_SAOS b on a.I_OSTYPE = b.ID
	left join MDL_AOS_SADB c on a.I_DBTYPE = c.ID
	left join (
		SELECT 
		i_psfbid,
		GROUP_CONCAT(IFNULL(S_SYSNAME,''),'-',IFNULL(S_SUPPLIER,''),'-',IFNULL(S_ACCTYPE,''),'-',IFNULL(S_MSGTYPE,''),';') `POC-对接信息`
		from MDL_AOS_SAPOCDOCK
		GROUP BY I_PSFBID
	)d on a.ID = d.I_PSFBID
	WHERE a.IS_DELETE = 0
)SFB on SFB.I_PRESALEID = ps.ID
left join mdl_aos_sapoinf po on ps.I_POID = po.ID
left join mdl_aos_sacustinf cust on po.I_CUSTID = cust.ID
left join plf_aos_auth_user sale on sale.ID = ps.S_SALEMAN
left join (SELECT * from plf_aos_dictionary prestype where DICT_TYPE = 'prestype')prestype on prestype.dict_code = ps.S_PRESTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'psapptype') psapptype on psapptype.dict_code = ps.S_OPERTYPE
left join plf_aos_auth_user u on ps.OWNER_ID = u.ID
where 1=1
	and ps.IS_DELETE = 0 and !(ps.S_APPSTATUS<>1 and ps.S_OPERTYPE='001')
	and ps.S_PRESTYPE = '03'