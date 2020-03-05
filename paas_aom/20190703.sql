SELECT
I_PRJID, S_MAINID, b.S_PRJNO,
a.CREATE_TIME, a.LAST_UPDATE_TIME,
S_ALTERSEQ `流水号`,
S_ROLENAME `角色名称`,
DL_ROLEPRICE `角色单价`,
case S_UNITS when 2 then '人月' when 1 then '人天' end `类型`,
DL_AMOUNT `预计人力数量`, a.IS_DELETE
from mdl_aos_prbankunp_his a
join mdl_aos_project b on a.I_PRJID = b.ID
where 1=1
-- and DATE_FORMAT(CREATE_TIME,'%Y%m%d') != DATE_FORMAT(LAST_UPDATE_TIME,'%Y%m%d')
and a.IS_DELETE = 0
-- and b.s_prjno like 'YY-2019-0148-78-208'
and S_MAINID = 718
-- GROUP BY S_MAINID, DATE_FORMAT(LAST_UPDATE_TIME,'%Y%m')
;

SELECT b.ID, b.I_PRJID, ngoss.getusername(s_userid), c.S_PRJNO, b.IS_DELETE
from mdl_aos_prbankunp b
left join mdl_aos_prmember a on a.S_THEIRROLE = b.ID and a.I_PRJID = b.I_PRJID
join mdl_aos_project c on b.I_PRJID = c.ID
where 1=1
-- and c.S_PRJNO like 'YY-2019-0148-78-208'
-- and b.id = 1607
and b.I_PRJID = 151725
and a.S_USERID = 608456
;


SELECT 
c.*,
a.S_USERID, ngoss.getusername(S_USERID) `员工姓名`, 
-- I_WORKDAY `工作日天数`,
case b.S_UNITS when 1 then '人天' when 2 then '人月' end `类型`,
S_THEIRROLE, b.S_ROLENAME `卖价角色`, b.DL_ROLEPRICE `卖价`, IFNULL(TRUNCATE(b.DL_AMOUNT,0),0) `预计人力数量`
FROM `mdl_aos_prmember` a
left join mdl_aos_prbankunp b on a.S_THEIRROLE = b.ID and a.I_PRJID = b.I_PRJID
join (
	SELECT id, S_PRJNO `项目编号`, S_PRJNAME `项目名称`
	from mdl_aos_project
	where IS_DELETE = 0 and S_PRJSTATUS<>'01'
) c on a.I_PRJID = c.id
where S_THEIRROLE is not null 
-- and c.`项目编号` = 'YY-2019-0148-78-208'
and a.I_PRJID = 151725
-- and b.id = 1607
and a.S_USERID = 608456