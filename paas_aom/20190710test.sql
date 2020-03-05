-- 项目名称 编号 所属部门 姓名 级别 报工 日期 时长 审批通过
SELECT
S_BGCODE '项目编号'	,
S_BGNAME '项目名称'	, 
case LENGTH(dawork.S_BUGETDPT)
when 10 then org1.ORG_NAME
when 13 then CONCAT(org1.org_name,'-', org2.org_name)
when 16 then CONCAT(org1.org_name,'-', org2.org_name, '-', org3.org_name) 
end '预算归属部门',
(select REAL_NAME from plf_aos_auth_user where id = dawork.S_APPLICANT) '申报员工姓名',
-- `级别`,
DATE_FORMAT(dawork.DT_WORKDATE,'%Y-%m-%d') '申报日期',
(select DICT_NAME from plf_aos_dictionary where dawork.S_DATETYPE = DICT_CODE and DICT_PARENT_CODE = 'dateType') '日期类型' , 
(select DICT_NAME from plf_aos_dictionary where dawork.S_WORKTYPE = DICT_CODE and DICT_PARENT_CODE = 'DoWorkType') '工时类型',
S_WORKTIMES `工时时长`
from mdl_aos_dawork dawork
left join mdl_aos_project p on dawork.S_PROJECT = p.ID 
left join plf_aos_auth_org org1 on org1.ORG_CODE = left(IFNULL(p.S_DEPT,dawork.S_BUGETDPT),10)
left join plf_aos_auth_org org2 on org2.ORG_CODE = left(IFNULL(p.S_DEPT,dawork.S_BUGETDPT),13)
left join plf_aos_auth_org org3 on org3.ORG_CODE = left(IFNULL(p.S_DEPT,dawork.S_BUGETDPT),16)
where 1=1
and left(S_BUGETDPT,10) in ('0001001034','0001001035')
and dawork.S_APPSTATUS = 1
and S_BUDGETYPE = 'YF'
and DATE_FORMAT(dawork.DT_WORKDATE,'%Y%m') BETWEEN 201901 and 201905
-- GROUP BY S_BGCODE, S_APPLICANT, DT_WORKDATE
ORDER BY dawork.S_BGCODE, dawork.S_APPLICANT, dawork.DT_WORKDATE