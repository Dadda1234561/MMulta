DROP TABLE IF EXISTS `smelting_tasks`;
CREATE TABLE `smelting_tasks`  (
  `player_id` int NOT NULL,
  `slot` int NOT NULL,
  `resource` int NOT NULL,
  `end_time` bigint NOT NULL,
  PRIMARY KEY (`player_id`, `slot`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;
