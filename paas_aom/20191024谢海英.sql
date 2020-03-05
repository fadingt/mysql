SELECT
S_PRJNO `项目编号`,
S_PRJNAME `项目名称`,
d.s_custname `客户名称`,
(SELECT dict_name from plf_aos_dictionary where DICT_CODE = a.S_PRJSTATUS and DICT_TYPE = 'prjstatus') `项目状态`,
CONCAT(a.DL_BUDGRRATE*100,'%') `预算毛利`,
a.DL_BUDCOAMTI `立项金额`,
a.DL_NINCOME `收入额(不含税)`,
	a.DL_BUDLABAMT `预算人力成本`,
	a.DL_BUDCOSAMT `预算费用成本`,
	a.DL_BUDPURAMT `预算采购成本`,
IFNULL(sjfy.realfee,0) `实际费用`,
IFNULL(rlcb.realcost,0) `实际人力`,
IFNULL(rlcb.realcost2,0) `实际人力(不含差旅费)`
from mdl_aos_project a
left join mdl_aos_sapnotify b on a.I_PRJNOTICE = b.ID
left join mdl_aos_sapoinf c on b.I_POID = c.ID
left join mdl_aos_sacustinf d on c.I_CUSTID = d.id
	left join (
			SELECT SUM(amt) realcost, budgetno, SUM(case when type not in (3,6) then amt else 0 end) realcost2
			FROM paas_aom.t_snap_fi_standardcost
			where 1=1
			and isactingstd = 0
			and budgetno is not null
			GROUP BY budgetno
		)rlcb on rlcb.budgetno = a.s_prjno
		left join (
			SELECT SUM(debit) as realfee, budgetno
			from paas_aom.t_snap_fi_voucher
			where 1=1
			and dc = '01' 
			and busitype not in (22002,27001,23002,24002)
			and zzno in (5301,6601,6602,6401)
			and yearmonth is not null
			and mxno not in (640133,640134)
			GROUP BY budgetno
		)sjfy  on sjfy.budgetno = a.s_prjno
where S_PRJSTATUS in ('05','09')
and a.IS_DELETE = 0
and DATE_FORMAT(a.DT_STARTTIME,'%Y%m') > 201812