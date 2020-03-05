SELECT
S_PJNO,S_PRJNAME,
SUM(DL_PRABILLAT) `项目实开金额`,
SUM(DL_PRABACKAT) `项目实回金额`,
S_ASSIGN,
S_VERSION `版本号`
FROM mdl_aos_evidence
where 1=1
and S_PJNO is not null
and IS_DELETE = 0
and S_VERSION = (SELECT MAX(S_VERSION) from mdl_aos_evidence)
GROUP BY S_PJNO