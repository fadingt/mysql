SELECT
a.S_PRJNO, a.DT_ALTERDATE
from mdl_aos_project_his a
join (
		SELECT MAX(ID) max_id, S_PRJNO
		from mdl_aos_project_his
		where S_PRJNO in (
			SELECT S_PRJNO
			from mdl_aos_project	
			where s_iszl = 2
-- 			and DT_ALTERDATE is not null
			and IS_DELETE =0
		)
		and DT_ALTERDATE is not null
		and S_ISZL = 2
		GROUP BY S_PRJNO
)b on a.id = b.max_id;

-- SELECT *
-- from t_snap_wf_participant
-- where DEF_NAME in (
-- '项目信息变更流程',
-- '应用项目立项审批'
-- )
-- and BUSINESS_KEY in (
-- 			SELECT ID
-- 			from mdl_aos_project
-- 			where s_iszl = 2
-- 
-- )
-- GROUP BY BUSINESS_KEY

