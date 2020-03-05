SELECT
S_PJNO, S_PRJNAME, S_PROCYCLE, SUM(DL_ACBILLAMT), SUM(DL_ACBACKAMT)

from mdl_aos_evidence
where S_VERSION = (SELECT MAX(S_VERSION) from mdl_aos_evidence)
group by S_PJNO
