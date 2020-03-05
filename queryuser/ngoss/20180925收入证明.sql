-- SELECT
-- 		a.projectid, b.projectno, b.projectname,
-- 		a.version, c.version_max,  a.budgetcontractamout, b.budgetcontractamout as budgetcontractamoutb, 
-- a.incometype, b.incometype as incometypeb,
-- 		case when a.budgetcontractamout = b.budgetcontractamout and a.version = c.version_max then 1 -- '最新生效'
-- 		when a.budgetcontractamout = b.budgetcontractamout and a.version != c.version_max then 2-- '之前版本生效'
-- 		when a.budgetcontractamout != b.budgetcontractamout then 0 -- '未生效'
-- 		end as flag
-- 		from t_project_incomeProof a
-- 		left join t_project_projectinfo b on a.projectid = b.projectid
-- 		left join (SELECT projectid, MAX(version) as version_max from t_project_incomeproof group by projectid) c on a.projectid = c.projectid
-- where a.projectid = 151587

SELECT
projectid, COUNT(*), SUM(flag)
from (
		SELECT
		a.projectid, b.projectno, b.projectname,
		a.version, c.version_max,  a.budgetcontractamout, b.budgetcontractamout as budgetcontractamoutb, 
a.incometype, b.incometype as incometypeb,
		case when a.budgetcontractamout = b.budgetcontractamout and a.version = c.version_max then 1 -- '最新生效'
		when a.budgetcontractamout = b.budgetcontractamout and a.version != c.version_max then 2-- '之前版本生效'
		when a.budgetcontractamout != b.budgetcontractamout then 0 -- '未生效'
		end as flag
		from t_project_incomeProof a
		left join t_project_projectinfo b on a.projectid = b.projectid
		left join (SELECT projectid, MAX(version) as version_max from t_project_incomeproof group by projectid) c on a.projectid = c.projectid
)x
GROUP BY x.projectid
HAVING
--  COUNT(*) = SUM(flag)
SUM(flag) > 2