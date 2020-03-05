SELECT 
-- cstg.ID, i_ckid, I_CASEID, cstg.I_POID, I_CKSTGID, DT_CHECKTIME, DT_CHECKDATE, DT_MAINEND, DT_MAINSTART, S_STGNAME, S_TYPE,
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'checkstg' and DICT_CODE = cstg.S_STGNAME) `验收阶段名称`,
cstg.ID, cstg.I_CKID, cstg.S_TYPE,
checkapp.S_CKNO,
 c.S_CASECODE, c.S_CASENAME
FROM `mdl_aos_sacheckstg` cstg
LEFT JOIN mdl_aos_sacase c on cstg.i_caseid = c.ID
left join mdl_aos_sacheckapp checkapp on checkapp.ID = cstg.I_CKID
where cstg.IS_DELETE = 0 and I_CASEID is not null and S_TYPE = 3
;



SELECT
(SELECT DICT_NAME from plf_aos_dictionary where DICT_TYPE = 'checkstg' and DICT_CODE = cstg.S_STGNAME) `验收阶段名称`,
cstg.ID, cstg.I_CKID, cstg.S_TYPE, cstg.DT_CHECKDATE, cstg.DT_CHECKTIME,
checkapp.S_CKNO,
poinf.S_POCODE, poinf.S_PONAME
from mdl_aos_sacheckstg cstg
left join mdl_aos_sapoinf poinf on poinf.ID = cstg.I_POID
left join mdl_aos_sacheckapp checkapp on checkapp.ID = cstg.I_CKID
where cstg.IS_DELETE = 0 and I_POID is not null and S_TYPE = 3
and S_CKNO = 'YSBG-00000003';


-- 商机	1
-- 事项	2
-- 验收报告	3
SELECT 
poinf.ID, poinf.S_POCODE,
COUNT(case when cstg.DT_CHECKTIME is not null then 1 END) `应验阶段数`,
COUNT(case when cstg.DT_CHECKDATE is not null then 1 END) `已验阶段数`
FROM `mdl_aos_sacheckstg` cstg
LEFT JOIN mdl_aos_sacase c on cstg.i_caseid = c.ID
left join mdl_aos_sapoinf poinf on poinf.ID = c.I_POID
where cstg.IS_DELETE = 0 and S_TYPE = 2
GROUP BY c.I_POID

union all

SELECT
poinf.ID, poinf.S_POCODE,
COUNT(case when cstg.DT_CHECKTIME is not null then 1 END) `应验阶段数`,
COUNT(case when cstg.DT_CHECKDATE is not null then 1 END) `已验阶段数`
from mdl_aos_sacheckstg cstg
left join mdl_aos_sapoinf poinf on poinf.ID = cstg.I_POID
where cstg.IS_DELETE = 0 and S_TYPE = 1
GROUP BY cstg.I_POID