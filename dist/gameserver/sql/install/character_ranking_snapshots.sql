SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- ----------------------------
-- Table structure for character_ranking_snapshots
-- ----------------------------
DROP TABLE IF EXISTS `character_ranking_snapshots`;
CREATE TABLE IF NOT EXISTS `character_ranking_snapshots`  (
  `char_id` int NOT NULL,
  `timestamp` bigint NOT NULL DEFAULT 0,
  `clan_id` int NULL DEFAULT 0,
  `class_id` int NULL DEFAULT 0,
  `race` int NULL DEFAULT NULL,
  `rebirths` bigint NULL DEFAULT NULL COMMENT 'can be migrated later to be exp',
  `server_rank` int NULL DEFAULT -1,
  `race_rank` int NULL DEFAULT -1,
  `class_rank` int NULL DEFAULT -1,
  `gear_score_rank` int NULL DEFAULT 0,
  `gear_score` int NULL DEFAULT 0,
  PRIMARY KEY (`char_id`, `timestamp`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
