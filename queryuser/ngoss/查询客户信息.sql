SELECT
		t1.custid AS custid, -- 客户ID
		t1.custno AS custno, -- 客户编号
		t1.custname AS custname, -- 客户名称
		t1.custtype AS custtype, -- 客户类型
		getusername(t1.tecpersonid) tecperson, -- 客户经理
		( SELECT linename from t_sys_mngunitinfo where unitid = (SELECT deptid from t_sys_mnguserinfo where userid = t1.tecpersonid) ) tecpersonunit,
		translatedict('IDFS000050',t1.custsector) as custsector, -- 行业
		t1.custcountry AS custcountry, -- 国家
		t1.custcity AS custcity, -- 城市
		t1.custaddress AS custaddress, -- 地址
		t1.custregion AS custregion, -- 区域
		t1.custpostcode AS custpostcode, -- 邮政编码
		t1.contact AS contact, -- 联系人
		t1.telephone AS telephone, -- 联系电话
		t1.approver AS approver, -- 审批人
		t1.createtime, -- 创建时间
		t1.lastmodtime -- 最后修改时间
FROM
		t_sale_custbasicdata t1