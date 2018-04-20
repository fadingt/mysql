set @para := 'username';
set @sql := CONCAT('select ',@para,' from ngoss.t_sys_mnguserinfo ');
PREPARE stmt from @sql;
-- EXECUTE stmt using user_id;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

EXECUTE 'SELECT * from t_sys_mngunitinfo';