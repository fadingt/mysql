SELECT *
FROM t_sys_dicttype
WHERE dictitem like 'IDFS000074'
-- WHERE applyarea like '%JSLY%'

SELECT *
FROM t_sys_dicttype
-- WHERE dictcname like '%解决%'
 WHERE dictename like '%businesstype%';


SELECT *
FROM t_sys_dictvalue
where dictname like '%人*月%' 
and dictvalue = 2
-- WHERE dictitem = 'IDFS000334';


SELECT *
FROM t_sys_dictvalue
WHERE dictitem = 'IDFS000073';