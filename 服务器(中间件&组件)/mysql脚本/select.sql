
# 脚本备份
SELECT DISTINCT welcome_id, qy_welcome_message_relation.*
FROM qy_welcome_message_relation
WHERE welcome_id IN ('1409077439056994304', '1419652755190136832', '1426082997144383488', '1426083694942351360', '1428197813057126400')
	AND (relation_type = 0
		OR (relation_type = 2
			AND relation_id = 1412661258817306624)
		OR (relation_type = 4
			AND relation_id IN ('1', '2', '1409886392510734336')))
	AND limit_type = 1
	AND source_type = 0


SELECT DISTINCT welcome_id
FROM qy_welcome_message_relation
WHERE welcome_id IN ('1409077439056994304', '1419652755190136832', '1426082997144383488', '1426083694942351360', '1428197813057126400')
	AND source_type = 0
	AND ((relation_type = 2
			AND relation_id = 1412661258817306624)
		OR (relation_type = 4
			AND relation_id IN ('1', '2', '1409886392510734336')))
	AND limit_type = 2
	AND source_type = 0






# 1.组织ID为1时,不通过组织查询(1.2 数据存在差异) 做下脚本记录
SELECT COUNT(1) FROM qy_employees_info e WHERE e.active_status = 1 AND e.status = 0;

SELECT e.id, e.employee_no, e.chinese_name, e.position_name, e.phone, e.role_type, e.active_status,
e.status, e.source, e.alias, e.leave_time, e.customer_num, e.chatgroup_num, e.create_time,
e.create_by, e.update_time, e.update_by, e.integral, s.id affiliateStoreId, s.org_code affiliateStoreNo,
s.org_name affiliateStoreName
FROM qy_employees_info e
LEFT JOIN qy_organization s ON s.id = e.store_id
LEFT JOIN qy_employees_bind eb on eb.emp_id = e.id
WHERE e.active_status = 1 and e.status = 0 order by e.create_time desc;

# 2.组织ID为1时,通过组织查询(1.2 数据存在差异)  做下脚本记录
SELECT e.id, e.employee_no, e.chinese_name, e.position_name, e.phone, e.role_type, e.active_status, e.status,
 e.source, e.alias, e.leave_time, e.customer_num, e.chatgroup_num, e.create_time, e.create_by,
e.update_time, e.update_by, e.integral, s.id affiliateStoreId, s.org_code affiliateStoreNo, s.org_name affiliateStoreName
FROM qy_employees_info e
LEFT JOIN qy_organization s ON s.id = e.store_id
LEFT JOIN qy_employees_bind eb on eb.emp_id = e.id
WHERE e.id in ( select om.emp_id from qy_organization_member om WHERE om.org_id in
( select descendant from qy_store_tree_paths where ancestor= (SELECT id FROM qy_organization WHERE org_code = 1) ) )
and e.active_status = 1 and e.status = 0 order by e.create_time desc;



EXPLAIN
    SELECT qywm.id, qywm.`code`, qywm.type, qywm.internal_title AS 'internalTitle', qywm.start_time AS 'startTime'
         , qywm.end_time AS 'endTime', qywm.create_by AS 'createBy', qywm.create_time AS 'createTime', qywm.`status`, qywm.global_flag AS 'globalFlag'
         , c.mini_program_title AS 'title'
    FROM qy_welcome_message qywm
             LEFT JOIN (
        SELECT wmmp.welcome_id, wmmp.mini_program_title
        FROM (
                 SELECT MIN(mmp.id) AS mmpId
                 FROM qy_welcome_message_mini_program mmp
                 GROUP BY mmp.welcome_id
             ) a
                 INNER JOIN qy_welcome_message_mini_program wmmp ON wmmp.id = a.mmpId
    ) c
                       ON qywm.id = c.welcome_id
    WHERE 1 = 1
      AND qywm.code = '1'
    ORDER BY qywm.global_flag DESC, qywm.create_time DESC
    LIMIT 0, 10



SELECT MIN(mmp.id) AS mmpId ,mmp.*
FROM qy_welcome_message_mini_program mmp
GROUP BY mmp.welcome_id

qy_welcome_message
qy_welcome_message_mini_program


## 欢迎语配置表
select *  from  qy_welcome_message where code = '1' ORDER BY global_flag DESC, create_time DESC;
## 欢迎语小程序关联表
select *  from  qy_welcome_message_mini_program where welcome_id='1409077439056994304';

