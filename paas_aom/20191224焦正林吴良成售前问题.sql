
			SELECT 
				ps.ID,
				ps.s_prescode `售前编号`,
				ps.S_PRESNAME `售前名称`,
				CONCAT(psapptype.dict_name, '-', prestype.DICT_NAME) `预算类型`,
ps.DL_SUMAMT `预计人天总额`,
TRUNCATE(ps.DL_OCCAMT,2) `占用人力`,
TRUNCATE(ps.DL_USEDAMT,2) `已使用人力`,
TRUNCATE(ps.DL_AVAILAMT,2) `可用人力`
			from MDL_AOS_SAPOPSAPP ps
			left join mdl_aos_sapoinf po on ps.I_POID = po.ID
			left join plf_aos_auth_user sale on sale.ID = ps.S_SALEMAN
			left join (SELECT * from plf_aos_dictionary prestype where DICT_TYPE = 'prestype')prestype on prestype.dict_code = ps.S_PRESTYPE
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'postatus') postatus on postatus.dict_code = po.S_POSTATUS
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'ApproStatus') appstatus on appstatus.dict_code = ps.S_APPSTATUS
			left join (SELECT * from plf_aos_dictionary where DICT_TYPE = 'psapptype') psapptype on psapptype.dict_code = ps.S_OPERTYPE
			left join plf_aos_auth_user u on ps.OWNER_ID = u.ID
			where ps.IS_DELETE = 0 and !(ps.S_APPSTATUS<>1 and ps.S_OPERTYPE='001')
and (ps.DL_SUMAMT = ps.DL_OCCAMT + ps.DL_USEDAMT + ps.DL_AVAILAMT)
-- TRUNCATE(ps.DL_OCCFEE,2) `占用费用`,
-- TRUNCATE(ps.DL_USEDAMT,2) `已使用费用`,
-- TRUNCATE(ps.DL_AVAILFEE,2) `可用费用`,
-- TRUNCATE(ps.DL_OCCAMT,2) `占用人力`,
-- TRUNCATE(ps.DL_USEDAMT,2) `已使用人力`,
-- TRUNCATE(ps.DL_AVAILAMT,2) `可用人力`			
-- 	ps.DL_PRESUMFEE `预计费用总额`,
--  ps.DL_SUMAMT `预计人天总额`,
711 9