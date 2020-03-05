SELECT
		m.contractid '合同id', m.contractno '合同编号',type,
		case when m.type in (1,3) then '框架协议' when m.type in (2,4) then '固定金额' end '类型',
		a.id '阶段id', a.stageno '阶段编号', a.stagedescription '阶段描述',
		b.id '订单id', b.pono '订单编号', c.id '订单阶段id'
FROM t_contract_main m
left join t_contract_stage a on m.contractid = a.contractid and m.type = 2
left join t_contract_order b on m.contractid = b.protocolorcontractid and m.type = 1
left join t_contract_orderstage c on b.id = c.poid
order by m.type, b.id, c.id, a.id
