SELECT
year(coinf.DT_YEARR) `客户商机年份`,
sale.REAL_NAME `客户商机销售负责人`,
salearea.S_NAME `销售所属区域`,
poinf.S_POCODE `项目商机编号`, poinf.S_PONAME `项目商机名称`,
cont.s_concode `合同编号`,
project.S_PRJNO `项目编号`, project.S_PRJNAME `项目名称`,
ngoss.translatedict('prjclass',project.S_PRJCLASS) `项目分类`,
ngoss.translatedict('prjstatus',project.s_prjstatus) `项目状态`,
DATE_FORMAT(project.DT_STARTTIME,'%Y-%m-%d') `开始日期`,
DATE_FORMAT(project.DT_ENDTIME,'%Y-%m-%d') `结束日期`,
DATE_FORMAT(project.DT_MAINEND,'%Y-%m-%d') `维护日期`,
project.DL_BUDCOAMTI `预算合同额`
from mdl_aos_sapoinf poinf
left join (SELECT * from mdl_aos_sacont where IS_DELETE=0 and S_APPSTATUS = 1)cont  on cont.I_POID = poinf.ID
left join mdl_aos_sapnotify note on note.I_POID = poinf.ID
left join mdl_aos_project project on project.I_PRJNOTICE = note.ID
left join mdl_aos_sacoinf coinf on coinf.ID = poinf.I_COID
left join mdl_aos_sacustinf cust on cust.ID = coinf.I_CUSTID
left join plf_aos_auth_user sale on sale.ID = coinf.S_SALEOWNER
left join mdl_aos_hrorg salearea on salearea.S_ORGCODE = left(sale.ORG_CODE,13)
where 1=1
and poinf.IS_DELETE = 0 and poinf.S_APPSTATUS = 1
and note.IS_DELETE =0
and project.IS_DELETE = 0 and project.S_APPSTATUS = 1