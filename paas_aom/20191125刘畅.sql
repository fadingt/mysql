SELECT
userid, username, `level`, budgetno, budgetname, yearmonth, SUM(worktimes) `人天`, SUM(traveltimes) `人天(差旅)`, SUM(standardcost) `标准成本(总)`, SUM(travelcost) `差旅成本`,
SUM(cardcost) `工资卡`, SUM(bonuscost) `奖金`, SUM(salary13cost) `13薪`
-- *
FROM `t_snap_project_standardcost_detail`
where budgettype = 'YY'
GROUP BY userid, budgetno, budgetid, yearmonth