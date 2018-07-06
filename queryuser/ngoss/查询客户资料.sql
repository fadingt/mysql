SELECT
     ( SELECT custname FROM t_sale_custbasicdata t3 WHERE t3.custid = t1.parentid ) as parentname,  -- 上级客户名称
     t1.custid AS custid, -- 客户ID
     t1.custno AS custno, -- 客户编号
     t1.custname AS custname, -- 客户名称
     t1.custtype AS custtype, -- 客户类型
     t.dictname as custsector, -- 行业
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
     t_sale_custbasicdata t1 INNER JOIN t_sale_bucustinfo t2 ON t1.custid = t2.custid
	LEFT JOIN  t_sys_dictvalue t on   t.dictvalue=t1.custsector and  dictitem='IDFS000050'