SELECT
`项目编号`,
IFNULL(`201612应收`,0) - IFNULL(`2016开票`,0) - IFNULL(`2015开票`,0),
IFNULL(`201612应收`,0)*1.06 - IFNULL(`2016开票`,0) - IFNULL(`2015开票`,0),
`201612未票应收`
FROM `query`.`unbilledar_term_project`
where `项目编号` like '%2016%'
-- YY-2016-0132-03