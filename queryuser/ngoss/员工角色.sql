SELECT * from t_sys_mnguserinfo
where username like '%吴良成%'
-- 32061

select * from t_sys_mngroleinfo
where roleid in (
SELECT role_id from t_sys_mnguserrole
where user_id = 32061
)