-- 费用部分 

SELECT
busino, zzno, mxno, mxname, financialbody, financialname, jremark, debit, budgetno, createtime,
busitype, busitypename
from t_snap_fi_voucher
where yearmonth is not null
and dc = 01;

SELECT 
base.*,
IFNULL(rlcb.realcost,0) `人力成本`,
IFNULL(fycb.`实际费用`,0) `实际费用`,
IFNULL(occfee.`报销费用`,0) `报销费用`,
IFNULL(cgcb.`采购成本`,0) `采购成本`,
IFNULL(occfee.`报销待审核费用`,0) `报销待审核费用`

from (
		SELECT 
			a.ID `预算ID`,
			S_BUDGTCODE `预算编号`,
			S_BUDGTNAME `预算名称`,
			CONCAT(b.dict_name,'-',d.S_GENRENAME) `预算类型`,
			DL_TOTAMONEY `预算总额`,
			case when d.S_GENRENAME like '%费用' then DL_TOTAMONEY else 0 end `预算费用`,
			case when d.S_GENRENAME like '%人工' then DL_TOTAMONEY else 0 end `预算人力`,
			null `id`, null `编号`, null `名称`,
			u.REAL_NAME `预算建立人`,
			ngoss.getfullorgname(a.S_BUDGETDPT) `预算归属部门`,
			ngoss.getfullorgname(u.ORG_CODE) `预算建立人所属部门`,
			DATE_FORMAT(a.DT_BEGINTIME, '%Y-%m-%d') `开始日期`,
			DATE_FORMAT(a.DT_ENDTIME, '%Y-%m-%d') `结束日期`,
			a.CREATE_TIME `创建日期`,
			null `预计人天`
			from MDL_AOS_FIBGTAPP a
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE like 'BGTAPLYTP') b on b.dict_code = a.S_BGTAPLYTP
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'TradSte') c on c.dict_code = a.S_BUDGETSTE
			left join mdl_aos_fibgtcost d on a.I_BGTCOSTID = d.ID
			left join plf_aos_auth_user u on u.ID = a.OWNER_ID
			where S_BUDGETSTE = 31 and a.IS_DELETE = 0

			union all
			SELECT 
				ps.ID,
				ps.s_prescode `售前编号`,
				ps.S_PRESNAME `售前名称`,
				CONCAT(psapptype.dict_name, '-', prestype.DICT_NAME) `预算类型`,
				IFNULL(ps.DL_PRESUMFEE,0) + IFNULL(ps.DL_SUMAMT,0) `总额`,
				ps.DL_PRESUMFEE `预计费用总额`,
				ps.DL_SUMAMT `预计人天总额`,
				ps.I_POID `项目商机ID`, po.S_POCODE `项目商机编号`,	po.S_PONAME `项目商机名称`,
				u.REAL_NAME,
				ngoss.getfullorgname(sale.ORG_CODE),
				ngoss.getfullorgname(u.ORG_CODE) `预算建立人所属部门`,
				DATE_FORMAT(ps.DT_BEGDATE, '%Y-%m-%d') `开始日期`,
				DATE_FORMAT(ps.DT_ENDDATE, '%Y-%m-%d') `结束日期`,
				ps.CREATE_TIME `创建日期`,
				ps.DL_SUMDAYS `预计人天`
			from MDL_AOS_SAPOPSAPP ps
			left join mdl_aos_sapoinf po on ps.I_POID = po.ID
			left join plf_aos_auth_user sale on sale.ID = ps.S_SALEMAN
			left join (SELECT * from plf_aos_dictionary prestype where DICT_TYPE = 'prestype')prestype on prestype.dict_code = ps.S_PRESTYPE
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'postatus') postatus on postatus.dict_code = po.S_POSTATUS
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') appstatus on appstatus.dict_code = ps.S_APPSTATUS
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'psapptype') psapptype on psapptype.dict_code = ps.S_OPERTYPE
			left join plf_aos_auth_user u on ps.OWNER_ID = u.ID
			where ps.IS_DELETE = 0 and !(ps.S_APPSTATUS<>1 and ps.S_OPERTYPE='001')

			union all

			SELECT 
			a.ID,
			S_COCODE `客户商机编号`,
			S_CONAME `客户商机名称`,
			'客户商机' `预算类型`,
			IFNULL(DL_PREFEE,0) `预算总金额`,
			DL_PREFEE `预计费用金额`,
			null `预算人力`,
			null, null, null,
			u.REAL_NAME `建立人`,
			ngoss.getfullorgname(a.ORG_CODE)`预算归属部门`,
			ngoss.getfullorgname(u.ORG_CODE) `预算建立人所属部门`,
			null `开始日期`,
			null `结束日期`,
			a.CREATE_TIME `创建日期`,
			null `预计人天`
			from mdl_aos_sacoinf a
			left join plf_aos_auth_user u on u.ID = a.OWNER_ID
			where a.IS_DELETE = 0 and!(a.S_APPSTATUS<>1 and a.S_OPERTYPE=1)

			union all

			SELECT 
			d.ID, d.s_prjno `项目编号`, d.S_PRJNAME `项目名称`, '研发项目' `预算类型`,
			d.DL_BUDTOLCOS `预算成本`, DL_BUDCOSAMT `预算费用成本`, DL_BUDLABAMT `预算人力成本`,
			a.ID,S_PLANCODE `研发计划编号`,S_PLANNAME `研发计划名称`,
			u.REAL_NAME `建立人`,
			ngoss.getfullorgname(a.S_DEPT) `预算归属部门`,
			ngoss.getfullorgname(u.ORG_CODE) `预算建立人所属部门`,
			DATE_FORMAT(DT_STARTTIME,'%Y-%m-%d') `开始日期`,
			DATE_FORMAT(DT_ENDTIME,'%Y-%m-%d')  `结束日期`,
			d.CREATE_TIME `创建日期`,
			I_BUDLABDAY `预计人天`
			from mdl_aos_prplan a
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'FPoperation') b on b.dict_code = a.s_opertype
			left join mdl_aos_prpstage c on c.I_PLANID = a.ID
			left join mdl_aos_project d on d.I_PRPSID = c.ID
			left join plf_aos_auth_user u on u.ID = d.OWNER_ID
			where 1=1
				and !(a.S_APPSTATUS<>1 and a.S_OPERTYPE=1) and a.IS_DELETE = 0
				and !(d.S_APPSTATUS<>1 and d.S_OPERTYPE ='01') and d.IS_DELETE = 0

			union all

			SELECT 
			d.ID, d.s_prjno `项目编号`, d.S_PRJNAME `项目名称`, '实施项目' `预算类型`,
			d.DL_BUDTOLCOS `预算成本`, DL_BUDCOSAMT `预算费用成本`, DL_BUDLABAMT `预算人力成本`,
			a.ID, a.S_POCODE `项目商机编号`,S_PONAME `项目商机名称`,
			u.REAL_NAME `建立人`,
			ngoss.getfullorgname(d.S_DEPT) `预算归属部门`,
			ngoss.getfullorgname(u.ORG_CODE) `预算建立人所属部门`,
			DATE_FORMAT(DT_STARTTIME,'%Y-%m-%d') `开始日期`,
			DATE_FORMAT(DT_ENDTIME,'%Y-%m-%d')  `结束日期`,
			d.CREATE_TIME `创建日期`,
			I_BUDLABDAY `预计人天`
			from mdl_aos_sapoinf a
			left join mdl_aos_sapnotify c on c.I_POID = a.ID
			left join mdl_aos_project d on d.I_PRJNOTICE = c.ID
			left join plf_aos_auth_user u on u.ID = d.OWNER_ID
			where d.IS_DELETE =0 and d.S_PRJSTATUS<>'01'

			UNION ALL

			SELECT 
				a.ID, a.S_BIDCODE `投标申请编号`, a.S_BIDNAME `投标名称`, '投标申请' `预算类型`,
				DL_BIDAMT `投标保证金金额`, IFNULL(DL_BIDAMT,0) `预算费用成本`, NULL `预算人力成本`,
				c.ID, c.S_POCODE `项目商机编号`, c.S_PONAME `项目商机名称`,
				u.REAL_NAME `建立人`,
				ngoss.getfullorgname(A.S_YSORGCODE) `建立人归属部门`,
				ngoss.getfullorgname(u.ORG_CODE) `预算建立人所属部门`,
				DATE_FORMAT(DT_BIDDATE,'%Y-%m-%d') `投标日期`,
				DATE_FORMAT(DT_ENDDATE,'%Y-%m-%d')  `预计投标结果日期`,
				a.CREATE_TIME `创建日期`,
				null `预计人天`
				from mdl_aos_sabidapp a
				left join plf_aos_auth_user u on a.OWNER_ID = u.ID 
				left join mdl_aos_sapoinf c on a.I_POID = c.ID
			where a.IS_DELETE = 0
)base
left join (
		SELECT
			budgetno, budgettype,	SUM(amt) realcost
		FROM `t_snap_fi_standardcost` standardcost
		where isactingstd = 1
		GROUP BY budgetno
)rlcb on rlcb.budgetno = base.`预算编号`
left join (
		SELECT  budgetno, SUM(debit) `实际费用`
		from t_snap_fi_voucher
		where 1=1
		and yearmonth is not null
		and zzno in (5301,6601,6602,6401)
		and mxno not in (140501,140502,14050333,14050334,640133,640134)
		and busitype not in (22002,27001,23002,24002)
		and budgetno is not null and budgetno <> '' and budgetno <> '12'
		GROUP BY budgetno
)fycb on fycb.budgetno = base.`预算编号`
left join (
		SELECT  budgetno, SUM(debit) `采购成本`
		from t_snap_fi_voucher
		where 1=1
		and yearmonth is not null
		and mxno in (140501,140502,14050333,14050334,640133,640134)
		and busitype not in (22002,27001,23002,24002)
		and budgetno is not null and budgetno <> '' and budgetno <> '12'
		GROUP BY budgetno
)cgcb on cgcb.budgetno = base.`预算编号`