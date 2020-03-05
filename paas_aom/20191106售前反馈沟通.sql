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
	SELECT ID, I_PRESALEID, CREATE_TIME `反馈时间`, S_PSFBCODE `售前反馈编码`, S_RECEPTION `沟通对象`, S_THEME `沟通主题`, S_PRORATE `可能商机`, S_BNKATTDES `附件描述`, null `竞争对手`
	from MDL_AOS_SAPOPSFB
	WHERE IS_DELETE = 0
)SFB on SFB.I_PRESALEID = ps.ID
left join mdl_aos_sapoinf po on ps.I_POID = po.ID
left join mdl_aos_sacustinf cust on po.I_CUSTID = cust.ID
left join plf_aos_auth_user sale on sale.ID = ps.S_SALEMAN
left join (SELECT * from plf_aos_dictionary prestype where DICT_TYPE = 'prestype')prestype on prestype.dict_code = ps.S_PRESTYPE
left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'psapptype') psapptype on psapptype.dict_code = ps.S_OPERTYPE
left join plf_aos_auth_user u on ps.OWNER_ID = u.ID
where 1=1
	and ps.IS_DELETE = 0 and !(ps.S_APPSTATUS<>1 and ps.S_OPERTYPE='001')
	and ps.S_PRESTYPE = '01'