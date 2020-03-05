SELECT 
	S_SUBNAME,S_SUBCODEID,S_HIERARCHY,S_OPENCLOSE,S_CONLEVEL,
	b.DICT_NAME
FROM `mdl_aos_account` a
left join plf_aos_dictionary b on a.S_SUBTYPE = b.DICT_CODE and b.DICT_TYPE = 'SUBTYPE'
where 1=1
and S_SUBCODEID in (5301,6601,6602,6401)
-- and S_SUBCODEID like  '140502%'
and (
S_SUBNAME like '%商品销售%'
OR S_SUBNAME like '%技术性%'
OR S_SUBNAME like '%软件%'
OR S_SUBNAME like '%硬件%'
-- OR S_SUBNAME like '%库存商品%'
);


SELECT a.S_SUBNAME, a.S_CONLEVEL, a.S_SUBCODEID, a.S_HIERARCHY,
	a1.S_SUBNAME,a2.s_subname, a3.s_subname, a4.S_SUBNAME,
	b.DICT_NAME
FROM `mdl_aos_account` a
join plf_aos_dictionary b on a.S_SUBTYPE = b.DICT_CODE and b.DICT_TYPE = 'SUBTYPE'
left join mdl_aos_account a1 on left(a.s_subcodeid,4) = a1.s_subcodeid and a1.S_HIERARCHY = 1
left join mdl_aos_account a2 on left(a.s_subcodeid,6) = a2.s_subcodeid and a2.S_HIERARCHY = 2
left join mdl_aos_account a3 on left(a.s_subcodeid,8) = a3.s_subcodeid and a3.S_HIERARCHY = 3
left join mdl_aos_account a4 on left(a.s_subcodeid,10) = a4.s_subcodeid and a4.S_HIERARCHY = 4
where a.S_CONLEVEL != a.S_HIERARCHY