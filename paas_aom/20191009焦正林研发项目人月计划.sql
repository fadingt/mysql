SELECT 
-- a.I_PRJID, 
s_prjno `项目编号`,
S_PYEARMON `年月`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then DL_PTOTALFEE+DL_RLABTLFEE else DL_PCOSAMT END `预算总成本`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then DL_RLABTLFEE else DL_PLABTLFEE END `预算人力成本`,
DL_PTOTALFEE `预算费用成本`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RLABHOUR/8 else I_PLABTLDAY END `预算人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK2/8 else I_PRANK2 END `2级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK3 else I_PRANK3 END `3级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK4 else I_PRANK4 END `4级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK5 else I_PRANK5 END `5级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK6/8 else I_PRANK6 END `6级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK7/8 else I_PRANK7 END `7级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK8/8 else I_PRANK8 END `8级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK9/8 else I_PRANK9 END `9级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK10/8 else I_PRANK10 END `10级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK11/8 else I_PRANK11 END `11级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK12/8 else I_PRANK12 END `12级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK13/8 else I_PRANK13 END `13级人天`,
case when S_PYEARMON < DATE_FORMAT(NOW(),'%Y%m') then I_RRANK14/8 else I_PRANK14 END `14级人天`,
DL_PTRAVEFEE `差旅费`,
DL_PTRAFFFEE `交通费`,
DL_PROOMFEE `宿舍费`,
DL_PSERVEFEE `招待费`,
DL_POTHERFEE `其他费用`
from mdl_aos_prmonthpl a
join (
	SELECT id, S_PRJNO 
	from mdl_aos_project 
	where S_PRJTYPE = 'YF' and left(S_DEPT,10) = '0001001034'
) b on a.I_PRJID = b.id
where IS_DELETE = 0
-- and EXISTS (SELECT id from mdl_aos_project where ID = a.I_PRJID and S_PRJTYPE = 'YF')
-- and a.i_prjid = 153078
ORDER BY I_PRJID +0

