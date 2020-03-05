SELECT 
	S_CASECODE,translatedict('SIGNTYPE',S_SIGNTYPE) `签约子类型`, 
	IFNULL(SUM(ass.DL_PRBILLAMT),0) `预开`, IFNULL(SUM(ass.DL_BACKAMT),0) `预回`
from mdl_aos_sacase sacase
left join mdl_aos_project prj on prj.I_POID = sacase.I_POID
left join (
		SELECT I_PROID, I_PROSTAGID, a.S_NAME, DL_BACKAMT, DL_PRBILLAMT
		FROM mdl_aos_saordass a where a.I_CONID is null and a.IS_DELETE = 0
)ass on prj.ID = ass.I_PROID
where sacase.IS_DELETE = 0
GROUP BY sacase.ID
