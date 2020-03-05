SELECT
*
FROM
(
		SELECT
			unit.calcdept,
			SUM(CASE	WHEN (`invoi`.`invoicetype` = '3') THEN `invoi`.`bta` ELSE `invoi`.`amt` END) amt
		FROM t_budget_paymentbill voucher
		JOIN `t_budget_reimbursement` `reim` ON `reim`.`paymentid` = `voucher`.`id`
		JOIN `t_budget_reimbursementdetail` `invoi`
		 ON `reim`.`id` = `invoi`.`reimbursementid` and `invoi`.`course` NOT IN ('161', '163')
		JOIN t_sys_mngunitinfo unit on unit.unitid = voucher.depid
		WHERE left(voucher.acctdate,4)=2018
		GROUP BY unit.calcdept
)t1
left join
(
	SELECT
		calcdept,
		SUM(jt+cl+zd+tx+bg+fl+gwc+bx+bgszl+qtzl+cw+gz) realfee2,
		sum(s_gz+s_wxyj),
		sum(prjamt+deptamt)
	FROM `t_report_feiyong_tian`
	where acctdate = 2018
	GROUP BY calcdept
) t2 on t1.calcdept = t2.calcdept