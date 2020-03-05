SELECT
x.number `旧结算单编号`,
	case when LOCATE('_',x.number) != 0 then CONCAT('JSD-',lpad(SUBSTRING_INDEX(x.number,'_',-1),8,0) )
	when LOCATE('-',x.number) != 0 then CONCAT('JSD-',lpad(SUBSTRING_INDEX(x.number,'-',-1),8,0) )
	else 0
	END
`新编号`
from (
SELECT number
from ngoss.`新建文本文档 (2)`
)x


;


SELECT LPAD(str,len,padstr)
