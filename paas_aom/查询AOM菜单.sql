SELECT *
from plf_aos_menu 
-- where MENU_NAME like '%项目动态%'
where VIEW_ID = 2654
;
SELECT 
-- DISTINCT MODULE_NAME, PHY_MODULE_NAME
a.MODULE_NAME, a.MODULE_CODE,  b.SHOW_COLUMNS, c.COLUMN_CODE,
c.COLUMN_NAME, c.ID
from plf_aos_module a
join plf_aos_view b on a.ID = b.MODULE_ID
left join plf_aos_column c on LOCATE(CONCAT(',',c.ID,','), CONCAT(',',b.SHOW_COLUMNS,',')) != 0
where 1=1
-- and a.ID = 460 
and b.ID = 2654
-- and MODULE_NAME like '%本部门项目%'
-- and a.MODULE_CODE = 'CONBILRF'
-- and b.VIEW_TYPE = 1
ORDER BY a.id;

SELECT a.ID, a.S_SEARCHKEY, a.S_SEANAME,
b.ID, b.S_COLNUM,b.S_COLNAME, b.S_COLDISPL, b.S_ISRESULT, b.S_ISSEARCH,
a.S_SEASQL
from mdl_aos_resql a
left join `mdl_aos_reconfig` b on a.ID = b.I_RESQLID
where a.S_SEARCHKEY = 'stagebill_period'
;

SELECT 
a.MODULE_NAME, a.MODULE_CODE, c.COLUMN_NAME, b.SHOW_COLUMNS, c.ID
from plf_aos_module a
join plf_aos_view b
join plf_aos_column c
where 1=1
and a.ID = b.MODULE_ID 
and c.id in (7112,7113,7114,7115,7116,7117,7118,7119,7120,7121,7122,7123,7124,7137,7125,7126,7127,7128,7129,7130,7131,7132,7133,7134,7135,7136,7138,7139,7140,7141)
and MODULE_NAME like '%合同阶段开票明细回款报表%'
and a.MODULE_CODE = 'CONBILRF'
and b.VIEW_TYPE = 1;


set @substr := '7112,7113,7114,7115,7116,7117,7118,7119,7120,7121,7122,7123,7124,7137,7125,7126,7127,7128,7129,7130,7131,7132,7133,7134,7135,7136,7138,7139,7140,7141';
set @str := 7113;
SELECT @str in (@substr);
SELECT 7112 in ('7112,7113,7114,7115');
SELECT 7112 = '7112,7113,7114,7115';