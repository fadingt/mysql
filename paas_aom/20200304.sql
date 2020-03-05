select
S_CONCODE `合同编号`,
S_NAME `结算单编号`,
S_CONNAME `合同名称`,
S_CONSTAGE `阶段名称`,
S_PJNO `项目编号`,
S_PRJNAME `项目名称`,
NGOSS.translatedict('PRJSTAGE',S_STAGENAME) `项目阶段名称`,
DATE_FORMAT(DT_PROBILLDT,'%Y-%m-%d %H:%m:%s') `项目预计开票日期`,
DATE_FORMAT(DT_PROBACKDT,'%Y-%m-%d %H:%m:%s') `项目预计回款日期`,
DL_PROBILLAT 	`项目预计开票金额`,
DL_PROBACKAT `项目预计回款金额`,
DATE_FORMAT(DT_PRABILLDT,'%Y-%m-%d %H:%m:%s') `项目实际开票日期`,
DATE_FORMAT(DT_PRABACKDT,'%Y-%m-%d %H:%m:%s') `项目实际回款日期`,
DL_PRABILLAT `项目实际开票金额`,
DL_PRABACKAT `项目实际回款金额`,
S_ASSIGNDT `分配日期`,
(SELECT username FROM ngoss.plf_aos_auth_user_bak WHERE userid = S_ASSIGN) as `分配人员`,
S_PROCYCLE `项目阶段周期`,
(SELECT DICT_NAME FROM ngoss.plf_aos_dictionary_bak WHERE DICT_TYPE='assignCategory' AND DICT_CODE=S_OPERTYPE) AS `操作类型`,
S_VERSION `版本号`,
a.S_OPERTYPE
from mdl_aos_evidence a
join (SELECT MAX(S_VERSION) max_version from mdl_aos_evidence where IS_DELETE = 0) b on a.S_VERSION = b.max_version
where a.IS_DELETE = 0 
and a.S_OPERTYPE <> '004'
-- and S_OPERTYPE = '003'