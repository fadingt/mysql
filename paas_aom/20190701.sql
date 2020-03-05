SELECT b.username, a.S_ROLENAME, b.salename
FROM `mdl_aos_pritowork` a
join (
SELECT username, yearmonth, userid, budgetno, budgetid, `level`, standardcost, travelcost, salename, saleamt,
curmonincome, curmontax, worktimes, worktimes_1
FROM t_snap_project_standardcost_detail
where 1=1
and budgettype = 'yy'
and salename is not null
and yearmonth = 201905
and budgetno like 'YY-2017-0023-02'
)b on a.S_REALNAME = b.username and b.budgetno = a.S_PRJNO
where a.S_ROLENAME != b.salename