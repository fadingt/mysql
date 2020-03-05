SELECT 
ID, DL_STANDCOST, I_LEVELNUM,
(SELECT I_rank from mdl_aos_rank where ID = a.I_LEVELNUM) as rank
from mdl_aos_labercost a
where IS_DELETE = 0