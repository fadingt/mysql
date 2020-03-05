SELECT
p.s_prjno `项目编号`, p.s_prjname `项目名称`, DL_BUDCOAMTI `项目立项金额`,
cont.S_CONCODE `合同编号`, cont.S_CONNAME `合同名称`,
	case 
	when cont.S_CONTYPE = '01' then cont.DL_CONAMT 
	when S_CONTYPE = '02' then (SELECT SUM(DL_STATEMAMT) from mdl_aos_sastatem where I_PROTNAME = cont.id and IS_DELETE = 0 and S_STATYPE= 1 and S_OPTYPE <> 003)
	else 0
	end`合同额`,
poinf.S_POCODE `项目商机编号`,
poinf.S_PONAME `项目商机名称`,
tecperson `客户经理`,
sale.real_name `销售代表`,
salearea.s_name `销售大区`
from mdl_aos_sapoinf poinf
join (
	SELECT b.I_POID, a.S_PRJNO, a.S_PRJNAME, a.S_DEPT, a.ID, a.DL_BUDCOAMTI
	from mdl_aos_project a
	left join mdl_aos_sapnotify b on a.I_PRJNOTICE = b.ID
	where a.IS_DELETE = 0 and left(a.S_DEPT,10) = '0001001027'
)p on poinf.id = p.i_poid
left join mdl_aos_sacont cont on poinf.ID = cont.I_POID
left join mdl_aos_sacustinf cust on poinf.I_CUSTID = cust.ID
left join (
		SELECT
			I_CUSTID, GROUP_CONCAT(S_DEPTL,'-',b.REAL_NAME ORDER BY s_deptl SEPARATOR ';') tecperson
		FROM `mdl_aos_sacusttech` a
		left join plf_aos_auth_user b on a.S_TECHID = b.ID
		GROUP BY a.I_CUSTID
)tec on cust.id = tec.i_custid
left join plf_aos_auth_user sale on poinf.S_SALEMAN = sale.id
left join mdl_aos_hrorg salearea on salearea.s_orgcode = left(sale.org_code,13)
where poinf.is_delete = 0 and cont.is_delete = 0
ORDER BY p.id, cont.id