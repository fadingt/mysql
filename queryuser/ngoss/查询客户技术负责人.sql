SELECT 
		custno '客户编号',
		custname '客户名称',
		custnameabb '客户简称',
		translatedict('IDFS000083',custtype) '客户类型',
		translatedict('IDFS000050', custsector) '行业类型',
		custcity '城市',
		infoex '技术负责人',
		getunitname((SELECT deptid FROM t_sys_mnguserinfo WHERE userid = tecpersonid)) '技术负责人部门'
FROM t_sale_custbasicdata cust;