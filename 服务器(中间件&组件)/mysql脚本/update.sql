
# 表结构  prod
ALTER table qy_welcome_message ADD  `config_levels_count` int DEFAULT '0' COMMENT '会员数';
ALTER table qy_welcome_message_relation modify column relation_type tinyint DEFAULT NULL COMMENT '类型(0-白名单全局 1-渠道编码，2-BA员工，3-会员类型, 4-组织ID)';

ALTER table qy_welcome_message_relation ADD  `limit_type` tinyint DEFAULT '1' COMMENT '限制类型( 1:白名单 2:黑名单)';
ALTER table qy_welcome_message_relation ADD  `source_type` bigint DEFAULT '0' COMMENT '0:欢迎语 1:导航  2:广告位';
ALTER table qy_welcome_message_relation ADD  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '备注: 0:欢迎语 1:导航  2:广告位';
ALTER table qy_welcome_message_relation modify column relation_type tinyint DEFAULT NULL COMMENT '类型(0-白名单全局 1-渠道编码，2-BA员工，3-会员类型, 4-组织ID)';

# 删除索引
DROP INDEX uq_relation_id_old_value ON qw_cdp_tag_search_history;
# 添加普通索引
ALTER table `qy_welcome_message_relation` ADD INDEX `welcome_relation_limit_index` (`welcome_id`,`relation_id`,`limit_type`) USING BTREE;
# 添加唯一索引 1
ALTER table qw_cdp_tag_search_history ADD UNIQUE KEY `uq_relation_id_old_value` (`ba_id`,`tag_code`,`item_value`,`show_item_value`) USING BTREE;
# 添加唯一索引 2
CREATE UNIQUE INDEX welcome_unique_index ON qy_welcome_message_relation (`welcome_id`,`relation_type`,`relation_id`,`org_id`,`limit_type`,`source_type`) USING BTREE;

# 重命名索引 prod
ALTER TABLE qy_welcome_message_relation RENAME INDEX welcome_unique TO welcome_unique_index;
ALTER TABLE qy_welcome_message_relation RENAME INDEX welcome_relation_limit TO welcome_relation_limit_index;

## 获取插入操作后的最新记录的主键ID(注意insert、LAST_INSERT_ID() 共一个db连接有效)
SELECT MAX(id) from  tmp;
SELECT LAST_INSERT_ID();
SELECT LAST_INSERT_ID() from  information_schema.`TABLES` WHERE TABLE_SCHEMA='ews_task' AND TABLE_NAME='tmp';

## 获取自增ID列,下条新增记录的主键ID
SELECT auto_increment as next_id FROM information_schema.`TABLES` WHERE TABLE_SCHEMA='ews_task' AND TABLE_NAME='tmp';
SELECT auto_increment +1 as next_id FROM information_schema.`TABLES` WHERE TABLE_SCHEMA='ews_task' AND TABLE_NAME='tmp';

##example:
/**
<insert id="ItemTable.addItem" parameterClass="itemDO">
insert into
    item_table (<include refid="itemDO.all_field_no_id" />)
values(#itemTitle#, #itemPrice#)
        <selectKey keyProperty="id" resultClass="java.lang.Long" >
    SELECT LAST_INSERT_ID() AS value
        </selectKey>
</insert>
**/



