SELECT
	flow.CREATE_TIME `登记日期`,
	S_FLOWCODE `账户流水编码`,
	ngoss.translatedict('FLOWBUSIN',S_FLOWBUSIN) `款项类型`,
	ngoss.translatedict('FLOWMONEY',S_FLOWMONEY) `款项种类`,
	ngoss.getsubjectname(I_FLOWACSUB) `会计科目`,I_FLOWACSUB,
	ngoss.getcompanyname(flow.I_FCBODY) `财务主体`,
	ngoss.translatedict('MNYFLOW',S_MNYFLOW) `资金流向`,
	ngoss.translatedict('S_ISNEXTYEA',S_YNALLOT) `是否需要分配`,
	flow.I_ACCOPERID `银行账号管理id`,
	bank.s_banknum `行号`,
	bank.S_BANKACT `账号`,
	sup.S_SUPNAME `供应商`, I_SUPLIERID,
	ngoss.getcustname(I_CUSTOMID) `客户`,
	ngoss.getusername(S_STAFFID) `员工姓名`,
	DT_OCCURDATE `费用发生日期`,
	DL_AMOUNT `金额`,
	S_REMARKS `摘要`,
	ngoss.translatedict('TradSte',S_FLOWSTATE) `账户流水状态`

from MDL_AOS_FIACCFLOW flow-- 登记账户流水
left join MDL_AOS_FIACCADM bank on bank.I_ACCOPERID = flow.i_accoperid
left join mdl_aos_pusuplie sup on sup.ID = flow.I_SUPLIERID
where flow.IS_DELETE = 0 and bank.IS_DELETE = 0