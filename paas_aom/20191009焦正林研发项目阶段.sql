SELECT
S_PRJNO,S_PRJNAME,
DL_BUDCOAMTI `立项金额`,
ngoss.translatedict('PRJSTATUS',S_PRJSTATUS) `项目状态`,
ngoss.translatedict('opertype', S_OPERTYPE) `项目操作类型`,
ngoss.translatedict('ApproStatus',S_APPSTATUS) `审批状态`,
ngoss.getusername(S_MANAGER) `项目经理`,
ngoss.getusername(S_DIRECTOR) `项目总监`,
ngoss.getfullorgname(S_DEPT) `项目所属部门`,
DATE_FORMAT(DT_STARTTIME,'%Y%m%d') `项目开始日期`,
DATE_FORMAT(DT_ENDTIME,'%Y%m%d') `项目结束日期`,
ngoss.translatedict('prjclass',S_PRJCLASS) `项目分类`,
stage.*
from mdl_aos_project project
left join (
		SELECT
			a.ID,I_PRJID,
			ngoss.translatedict('PRJSTAGE',S_STAGENAME) `项目阶段名称`,
			DATE_FORMAT(DT_PSTADATE,'%Y-%m-%d') `阶段开始日期`,
			DATE_FORMAT(DT_PENDDATE,'%Y-%m-%d') `阶段结束日期`,
			ngoss.translatedict('trfl',S_ISMARKER) `是否里程碑`,
			T_DECRIBE `交付物描述`,
			ngoss.translatedict('finiType',S_FINSTATUS) `完成状态`,
			DT_FINDATE `阶段完成时间`,
			ngoss.translatedict('ApproStatus', a.S_APPSTATUS)`阶段审批状态`
		from mdl_aos_prstage a
		where a.IS_DELETE = 0
		and EXISTS (SELECT ID from mdl_aos_project where S_PRJTYPE = 'YF' and ID = a.I_PRJID)
)stage on stage.I_PRJID = project.ID
where S_PRJTYPE = 'YF'
and left(project.S_DEPT,10) = '0001001034'
ORDER BY project.ID+0, stage.ID+0