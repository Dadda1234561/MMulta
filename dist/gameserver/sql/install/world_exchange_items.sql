SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for world_exchange_items
-- ----------------------------
DROP TABLE IF EXISTS `world_exchange_items`;
CREATE TABLE `world_exchange_items`  (
                                         `world_exchange_id` bigint(20) NOT NULL,
                                         `item_object_id` bigint(20) NOT NULL,
                                         `item_status` smallint(6) NOT NULL,
                                         `category_id` smallint(6) NOT NULL,
                                         `price` bigint(20) NOT NULL,
                                         `old_owner_id` bigint(20) NOT NULL,
                                         `start_time` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                         `end_time` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                         `currency` INT NOT NULL DEFAULT '0',
                                         PRIMARY KEY (`world_exchange_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
