SELECT
S_PRJCODE, S_PRJNAME, S_CONTRACT, S_CONTNAME,
S_CONCYF, S_HTRELAT,
S_PRJRELAT
FROM mdl_aos_pjrtoconc
-- where S_CONTRACT = 'YY-2013-0096-1'
where S_PRJCODE = 'YY-2013-1099';

SELECT
	a.S_CONCODE `合同编号`,
	a.S_CONNAME `合同名称`,
	ngoss.translatedict('ApproStatus',a.S_APPSTATUS) `合同审批状态`,
	ngoss.translatedict('CONOPERTYPE',a.S_OPERTYPE) `合同操作类型`,
	case a.IS_DELETE when 0 then '否' when 1 then '是' end `合同是否删除`,
	b.S_POCODE `项目商机编号`,
	b.S_PONAME `项目商机名称`,
	ngoss.translatedict('ApproStatus',b.S_APPSTATUS) `项目商机审批状态`,
	case b.S_OPERTYPE when 001 then '商机新增' when 002 then '商机通过' end `项目商机操作类型`,
	case b.IS_DELETE when 0 then '否' when 1 then '是' end `项目商机是否删除`,

	d.S_PRJNO `项目编号`,
	d.S_PRJNAME `项目名称`,
	ngoss.translatedict('ApproStatus',d.S_APPSTATUS) `项目审批状态`,
	ngoss.translatedict('opertype',d.S_OPERTYPE) `项目操作类型`,
	case d.IS_DELETE when 0 then '否' when 1 then '是' end   `项目商机是否删除`
from mdl_aos_sacont a
left join mdl_aos_sapoinf b on a.I_POID = b.ID
left join mdl_aos_sapnotify c on c.I_POID = b.ID
left join mdl_aos_project d on d.I_PRJNOTICE = c.ID