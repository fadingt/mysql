				SELECT 
getcustname(custid),
cb.*
				FROM t_sale_customerbusiness cb
	WHERE businessno in(
'YY-2017-0179',
'YY-2017-0196',
'YY-2017-0197'
)