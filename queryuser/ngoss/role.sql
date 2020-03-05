
SELECT * from t_sys_mngroleinfo
where roleid in (
SELECT role_id from t_sys_mngrolemodule
where module_id in (
SELECT moduleid from t_sys_mngmoduleinfo
where modulename in (
'全面预算成本费用',
'查询科目发生额',
'查询已记账的支出凭单（标准成本工资）'
)))

SELECT * from t_sys_mngroleinfo
where roleid in(
SELECT role_id from t_sys_mnguserrole where user_id =
 (SELECT userid from t_sys_mnguserinfo where username like '%吴晶晶%')
)