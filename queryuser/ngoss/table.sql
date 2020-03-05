-- select * from information_schema.tables  
-- where TABLE_SCHEMA='ngoss' 
-- AND TABLE_NAME = 't_sys_mnguserinfo';
-- 
-- SELECT sum(DATA_LENGTH)+sum(INDEX_LENGTH) FROM information_schema.TABLES 
-- where TABLE_SCHEMA='ngoss';


-- 按字段名查表
SELECT * FROM information_schema.columns
WHERE 1=1
-- and COLUMN_COMMENT like '%人月%'
-- and TABLE_NAME like '%inout%' 
and COLUMN_NAME like '%idnumber%' 
-- and TABLE_NAME = 't_contract_main'
AND TABLE_SCHEMA='ngoss';



SELECT * FROM information_schema.`TABLES`
WHERE TABLE_NAME like '%inout%'
AND TABLE_SCHEMA='ngoss';

SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_COMMENT  FROM information_schema.columns
WHERE 1=1
-- and COLUMN_COMMENT like '%人月%'
and TABLE_NAME like '%inout%' 
-- and COLLATION_NAME like '%line%'
-- and COLUMN_NAME like '%inout%' 
-- and TABLE_NAME = 't_contract_main'
AND TABLE_SCHEMA='ngoss';