SELECT 
	old.*, new.ACCOUNT_PWD `AOM密码`
from(
SELECT
	SUBSTRING_INDEX(a.username,'-',1) as '姓名', a.usercode AS '工号', a.`password` AS '密码',
-- 	b.unitlist AS '部门id', b.remark4 AS '部门名称'
	c.ORG_TREE '部门id', c.ORG_NAME '部门名称', 'oa' type
-- 	case when b.LAST_UPDATE_TIME is not null then 'AOM已修改' else 'OA' end as type
from ngoss.t_sys_mnguserinfo a, paas_aom.plf_aos_auth_user b, 
(
		SELECT 
			case LENGTH(a.S_ORGCODE)
			when 10 then CONCAT(c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			when 13 then CONCAT(d.S_NAME,'-',c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			when 16 then CONCAT(e.S_NAME,'-',d.S_NAME,'-',c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			end as ORG_NAME,
			case LENGTH(a.S_ORGCODE)
			when 10 then CONCAT('|',c.S_ORGCODE,'|',b.S_ORGCODE,'|',a.S_ORGCODE,'|')
			when 13 then CONCAT('|',d.S_ORGCODE,'|',c.S_ORGCODE,'|',b.S_ORGCODE,'|',a.S_ORGCODE,'|')
			when 16 then CONCAT('|',e.S_ORGCODE,'|',d.S_ORGCODE,'|',c.S_ORGCODE,'|',b.S_ORGCODE,'|',a.S_ORGCODE,'|')
			end as ORG_TREE, a.S_ORGCODE
		FROM paas_aom.`mdl_aos_hrorg` a
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) b on a.S_PORGCODE = b.S_ORGCODE
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) c on b.S_PORGCODE = c.S_ORGCODE
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) d on c.S_PORGCODE = d.S_ORGCODE
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) e on d.S_PORGCODE = e.S_ORGCODE
) c
-- ngoss.t_sys_mngunitinfo b
where  1=1
and a.userid = b.id and b.ORG_CODE = c.S_ORGCODE 
AND a.staf_type!=8 
AND a.userid NOT in (606699,606700,606701,606702,06703,606704)


union ALL



SELECT
	SUBSTRING_INDEX(a.REAL_NAME,'-',1) as '姓名', a.ACCOUNT_ID AS '工号', 
	'E10ADC3949BA59ABBE56E057F20F883E' AS '密码',-- 123456
	b.ORG_TREE '部门id', b.ORG_NAME '部门名称', 'AOM'
from  plf_aos_auth_user a,
(
		SELECT 
			case LENGTH(a.S_ORGCODE)
			when 10 then CONCAT(c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			when 13 then CONCAT(d.S_NAME,'-',c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			when 16 then CONCAT(e.S_NAME,'-',d.S_NAME,'-',c.S_NAME,'-',b.S_NAME,'-',a.S_NAME)
			end as ORG_NAME,
			case LENGTH(a.S_ORGCODE)
			when 10 then CONCAT('|',c.S_ORGCODE,'|',b.S_ORGCODE,'|',a.S_ORGCODE,'|')
			when 13 then CONCAT('|',d.S_ORGCODE,'|',c.S_ORGCODE,'|',b.S_ORGCODE,'|',a.S_ORGCODE,'|')
			when 16 then CONCAT('|',e.S_ORGCODE,'|',d.S_ORGCODE,'|',c.S_ORGCODE,'|',b.S_ORGCODE,'|',a.S_ORGCODE,'|')
			end as ORG_TREE, a.S_ORGCODE
		FROM paas_aom.`mdl_aos_hrorg` a
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) b on a.S_PORGCODE = b.S_ORGCODE
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) c on b.S_PORGCODE = c.S_ORGCODE
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) d on c.S_PORGCODE = d.S_ORGCODE
		left join (SELECT S_NAME, S_ORGCODE, S_PORGCODE, LENGTH(S_ORGCODE) l from paas_aom.mdl_aos_hrorg) e on d.S_PORGCODE = e.S_ORGCODE
) b, mdl_aos_empstaff c
where 1=1
	and a.ORG_CODE = b.S_ORGCODE and a.ID = c.I_USERID
	and c.S_YPSTATE != 11
	and a.id not in (SELECT userid from ngoss.t_sys_mnguserinfo)
)old
left join plf_aos_auth_user new on old.`工号` = new.ACCOUNT_ID
ORDER BY old.`工号`
;
-- SELECT unitid,unitname FROM ngoss.t_sys_mngunitinfo WHERE isdel=0;
-- AOM修改密码 正常 新增用户
-- SELECT S_ORGCODE,s_name from paas_aom.mdl_aos_hrorg;