select * from information_schema.tables  
where TABLE_SCHEMA='ngoss' 
AND TABLE_NAME = 't_sys_mnguserinfo';

SELECT sum(DATA_LENGTH)+sum(INDEX_LENGTH) FROM information_schema.TABLES 
where TABLE_SCHEMA='ngoss';


-- 按字段名查表
SELECT * FROM information_schema.columns
WHERE COLUMN_COMMENT like '%签约公司%'
AND TABLE_SCHEMA='ngoss';
