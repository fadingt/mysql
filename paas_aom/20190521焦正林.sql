SELECT 
a.S_BGTYEARID `预算ID`,
	a.CREATE_TIME `创建日期`,
	a.LAST_UPDATE_TIME `最后修改日期`,
	ngoss.getusername(a.OWNER_ID) `创建人`,
	year(a.DT_PARTYEAR) `年份`,

	ngoss.translatedict('BUDGETYPE',a.S_BUDGETYPE) `预算类别`,
	ngoss.getfullorgname(a.S_BUDGETDPT) `预算所属部门`,
-- 	I_BGTCOSTID `预算费用类别`,
	b.S_GENRENAME `预算费用类别`,
	a.DL_TOTAMONEY `总金额`,
	a.DL_GRANMONEY `已下发总金额`,
	a.DL_LOWERHAMT `下发总金额`,
	a.DL_APPENDAMT `追加年度总金额`,
	a.DL_RELEMONEY `释放金额`,
	a.DL_ALLOMONEY `分配金额`,
	a.DL_OCCUMONEY `占用金额`,
	a.DL_USEMONEY `使用金额`,
	a.DL_USABMONEY `可用金额`

FROM `mdl_aos_fibgtyear` a
left join mdl_aos_fibgtcost b on a.I_BGTCOSTID = b.ID
-- left join MDL_AOS_FIBGTYEAR c on a.S_BGTYEARID = c.ID
where a.IS_DELETE = 0
