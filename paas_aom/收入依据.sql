SELECT
t1.S_PRIDS,
	p.S_PRJNO, p.S_PRJNAME, PBaseType.dict_name `依据状态(从项目信息查询)`, 
	t1.`依据状态` `依据状态(从收入依据查询)`, t1.`收入依据类型`,
	t1.`可确认收入额`, t1.`收入确认方式`, t1.`组织机构`,
t1.DT_FULLDATE `依据充分日期`, p.DT_FULLDATE
	
from mdl_aos_project p
left join (
		SELECT 
		p.DT_FULLDATE ,
		S_PRIDS,p.ID,BaseType.dict_name `收入依据类型`,
		ngoss.getfullorgname(p.ORG_CODE) `组织机构`,
		ngoss.getusername(p.OWNER_ID) `负责人`,
		DL_CONINAMT `可确认收入额`,
		incomeway.DICT_NAME `收入确认方式`,
		PBaseType.DICT_NAME `依据状态`,-- S_BASISSTUS
		ApproStatus.DICT_NAME `审批状态`,-- S_APPSTATUS
		baseopera.DICT_NAME `审批类型`-- S_OPERTYPE 
		from mdl_aos_prinbases p
		left join mdl_aos_prinbased p2 on p2.I_BASEID = p.ID
		join (SELECT MAX(ID+0) as id2 from mdl_aos_prinbased where IS_DELETE = 0 GROUP BY I_BASEID) p3 on p2.id = p3.id2
		left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') ApproStatus on ApproStatus.DICT_CODE = p.S_APPSTATUS
		left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'baseopera') baseopera on baseopera.DICT_CODE = p.S_OPERTYPE
		left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'PBaseType') PBaseType on PBaseType.DICT_CODE = p.S_BASISSTUS
		left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'INCOMEWAY') incomeway on incomeway.DICT_CODE = p.S_INCOMEWAY
		left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'BaseType') BaseType on BaseType.dict_code = p2.S_BASETYPE
		where 1=1
		and p.IS_DELETE = 0  and p.S_APPSTATUS = 1
)t1 
on p.id = t1.S_PRIDS
		left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'PBaseType') PBaseType on PBaseType.DICT_CODE = p.S_BASEFULL

where 1=1
and p.IS_DELETE = 0
-- and p.S_PRJSTATUS <>1
and p.S_PRJTYPE = 'YY'
-- and p.s_prjno like 'YY-2019-0167-0005-456'
and p.S_PRJNO like 'YY-2019-0128-0002-416'