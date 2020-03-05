SELECT
p.*, t.yearmonth `年月`, 
inc.`收入(不含税)`, inc.`税额`, inc.`收入`,
IFNULL(rlcost.worktimes,0) `当月报工(人天)`
from (
	SELECT member.*,
	p.ID,	S_PRJNO `项目编号`, S_PRJNAME `项目名称`,
	ngoss.translatedict('prjclass',S_PRJCLASS) `项目类型`,
	ngoss.getfullorgname(S_DEPT) `项目所属部门`,
	porg.S_FIN_CODE `财务编码`,
	ngoss.getcompanyname(S_COMPNO) `财务主体`,
	DATE_FORMAT(p.DT_STARTTIME,'%Y-%m-%d') `开始日期`,
	DATE_FORMAT(p.DT_ENDTIME,'%Y-%m-%d') `结束日期`,
	DATE_FORMAT(p.DT_MAINEND,'%Y-%m-%d') `维护日期`,
	basetype.`收入依据类型`, ngoss.translatedict('PBaseType',p.S_BASEFULL) `是否充分`	
	from mdl_aos_project p
	left join mdl_aos_hrorg porg on porg.S_ORGCODE = p.S_DEPT
	left join (
			SELECT S_PRIDS, GROUP_CONCAT(p2.S_BASETYPE) S_BASETYPE, GROUP_CONCAT(BaseType.dict_name) `收入依据类型`
			from mdl_aos_prinbases p
			left join mdl_aos_prinbased p2 on p2.I_BASEID = p.ID
			join (SELECT MAX(ID+0) as id2 from mdl_aos_prinbased where IS_DELETE = 0 GROUP BY I_BASEID) p3 on p2.id = p3.id2
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'BaseType') BaseType on BaseType.dict_code = p2.S_BASETYPE
			where p.IS_DELETE = 0  and p.S_APPSTATUS = 1
			GROUP BY S_PRIDS
	) basetype on basetype.S_PRIDS = p.id
	left join (
			SELECT 
			a.I_PRJID, a.S_USERID, c.REAL_NAME `员工姓名`, 
			case b.S_UNITS when 1 then '人天' when 2 then '人月' end `类型`,
			S_THEIRROLE, b.S_ROLENAME `卖价角色`, b.DL_ROLEPRICE `卖价`, TRUNCATE(b.DL_AMOUNT,0) `预计人力数量`
			FROM `mdl_aos_prmember` a
			left join mdl_aos_prbankunp b on a.S_THEIRROLE = b.ID and a.I_PRJID = b.I_PRJID
			join plf_aos_auth_user c on a.S_USERID = c.ID
			where a.S_THEIRROLE is not null
	)member on member.I_PRJID = p.ID
	where p.IS_DELETE =0 and p.S_PRJSTATUS<> 01 and p.S_PRJTYPE = 'yy'
)p
join (
	SELECT DISTINCT DATE_FORMAT(DT_CANDAY,'%Y%m') as yearmonth
	from mdl_aos_canlender
	where DATE_FORMAT(DT_CANDAY,'%Y%m') <= (SELECT MAX(yearmonth) from t_snap_income_projectincome_final)
)t
left join (
	SELECT
	projectid, yearmonth,
	SUM(curmonincome+adjustincome+adjusttax) `收入(不含税)`, 
	SUM(curmontax) `税额`,
	SUM(curmonincome+adjustincome+adjusttax+curmontax) `收入`
	from t_snap_income_projectincome_final
	where yearmonth > 201812 and (calctype != 0 or calctype is NULL)
	GROUP BY projectid, yearmonth
) inc on inc.projectid = p.ID and inc.yearmonth = t.yearmonth

left join (
	SELECT 
		userid, username, yearmonth, budgetno, budgetid, `level` `员工级别`, 
		SUM(worktimes) worktimes, SUM(worktimes_1) `当月报工(差旅人天)`, 
		SUM(standardcost) `标准成本`, SUM(travelcost) `差旅成本`
	from t_snap_project_standardcost_detail
	where budgettype = 'yy'
	GROUP BY budgetno, userid, yearmonth
)rlcost on rlcost.budgetid = p.ID and rlcost.yearmonth = t.yearmonth and rlcost.userid = p.S_USERID