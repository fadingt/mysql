SELECT *, IFNULL(pono,stagename) postano
FROM 
			(SELECT
					contractid,
					contractno,-- 合同编号
					contractname,-- 合同名称
					begintime,-- 签约日期
					type, -- 合同类型
					contractprice,-- 合同金额
					getcustname(firstparty) custname,-- 客户名称
					getunitname(secondparty) financialbody,-- 财务主体
					effectstatus,-- 状态
					getusername(saleid) salename,-- 所属销售
					(SELECT unitid FROM t_sys_mngunitinfo WHERE unitid = (SELECT deptid FROM t_sys_mnguserinfo u WHERE userid = saleid)) saleunit,-- 销售所属部门id
					(SELECT unitname FROM t_sys_mngunitinfo WHERE unitid = (SELECT deptid FROM t_sys_mnguserinfo u WHERE userid = saleid)) saleunitname-- 销售所属部门
			FROM t_contract_main
			WHERE effectstatus != 5) c
		left	JOIN 
				(SELECT *,
						(CASE WHEN sbillamt = 0 THEN '未开票' 
										WHEN sbillamt>0 AND sreceamt<sbillamt THEN '已开未回' 
									WHEN sbillamt = sreceamt THEN '已回完' else '冲正' END) billstatus,-- 发票状态
						(CASE WHEN ybillamt = yreceamt THEN '阶段性开票'
									WHEN ybillamt > yreceamt THEN '全票的首阶段' 
									WHEN ybillamt < yreceamt && ybillamt = 0 THEN '全票的后续阶段' ELSE '其它' END) battri,-- 发票属性
						(sbillamt-sreceamt) yszk,-- 应收账款
						(sbillamt/ybillamt) sbper,-- 实际开票比例：实开/预开
						(sreceamt/sbillamt) srper,-- 实际回款比例：实回/实开
						(CASE WHEN sbillamt = sreceamt AND sbillamt != 0 THEN TO_DAYS(srecedate)-TO_DAYS(sbilldate) 
									WHEN sbillamt = 0 THEN 0 
									WHEN sbillamt > 0 AND sreceamt < sbillamt THEN TO_DAYS(CURDATE())-TO_DAYS(sbilldate)  END) recedur-- 回款周期（天）
				FROM
					(SELECT contractid yscontractid, id ysstageid, 
									IFNULL(ybillamt, 0) ybillamt,--  预计开票金额
									IFNULL(sbillamt, 0) sbillamt,--  实际开票金额
									ybilldate,-- 预计开票时间
									sbilldate,-- 实际开票时间
									IFNULL(yreceamt, 0) yreceamt,-- 预计回款金额
									IFNULL(sreceamt, 0) sreceamt,-- 实际回款金额
									yrecedate,-- 预计回款时间
									srecedate,-- 实际回款时间
									stagename,-- 阶段描述
									pono,-- 阶段（订单）编号
									typename-- 合同类型
						FROM t_contract_stage_ys_tian
						WHERE IFNULL(left(ybilldate, 4),0) >=2016 AND IFNULL(left(yrecedate , 4),0)>=2016 ) y) ys ON ys.yscontractid = c.contractid
		LEFT JOIN (SELECT id sstageid, stageno from t_contract_stage) s ON s.sstageid = ys.ysstageid
		LEFT JOIN
			(SELECT
					cid,
					sum(ifnull(case when year<2016 then bill else 0 end,0)) bb6,
					sum(ifnull(case when year<2016 then rece else 0 end,0)) rb6,
					sum(ifnull(case when year>=2016 then bill else 0 end,0)) bae6,
					sum(ifnull(case when year>=2016 then rece else 0 end,0)) rae6
					FROM (
					SELECT contractid cid, sum(sbillamt) bill, sum(sreceamt) rece, year FROM (
									select contractid,contractno,0 as sbillamt,sreceamt,left(srecedate,4) year from t_contract_stage_ys_tian t
									union all
									select contractid,contractno,sbillamt,0,left(sbilldate,4) from t_contract_stage_ys_tian t1
									union ALL
									select contract_id,contract_no,bill_amt_sum,rece_amt_sum,left(income_month,4) from t_contract_month_income t
					)x GROUP BY contractid,`year` )cc GROUP BY cid) xx ON xx.cid = c.contractid
		LEFT JOIN (SELECT protocolorcontractid, stageid bstageid, orderstageid,  billingno, applytime, invoicestatus
							FROM t_bill_main
							WHERE invoicestatus = 3
							) b ON (b.bstageid = ys.ysstageid OR b.orderstageid = ys.ysstageid) AND b.protocolorcontractid = c.contractid

where 1=1 AND billstatus != '已回完'
ORDER BY saleunitname, salename, c.contractid, sstageid
