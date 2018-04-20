select
	t.billno,
	-- zddate,
	pzleibie,
	brno as pzno,
	usercode as suofudanshuju,
	zhaiyao,
	course,
	amt,
	-- daifang,
	-- jiefangaccount,
	-- daifangaccount,
	-- ybjiefang,
	-- zhidanren,
	-- jieduanfangshibianma,
	-- piaojuhao,
	-- pjdate,
	deptname,
	-- zybianma,
	-- kehubianma,
	-- gongyingshangno,
	-- yewuyuan,
	extend1,
	acctcreatdate,
	financialbody,
	x.brno,
	x.usercode
from t_report_cost_voucher_fy t

left join
(
	SELECT *
	FROM
	(
		SELECT userid, id, billno, financialbody, financialbodyname, `status` FROM t_budget_paymentbill a
		UNION ALL
		SELECT userid, id, billno, financialbody, financialbodyname, 1 FROM t_budget_paymentbill_manual b
	) ab
) tt on tt.billno = t.billno

LEFT JOIN
(
	SELECT userid, usercode, brno FROM t_sys_mnguserinfo userinfo
	LEFT JOIN t_sys_mngunitinfo unitinfo on unitinfo.unitid = userinfo.deptid
) x on tt.userid = x.userid

;

SELECT *, acctstatus, status from  t_budget_paymentbill
WHERE  id = 2338;'ZCPD-00002390'

SELECT * FROM t_report_cost_voucher_fy
-- WHERE billno = 'ZCPD-00002390';2338
WHERE billno = 'ZCPD-00031690';346

SELECT * FROM t_report_cost_voucher_fy
WHERE id = 346