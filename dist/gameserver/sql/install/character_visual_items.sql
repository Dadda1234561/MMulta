-- ----------------------------
-- Table structure for character_visual_items
-- ----------------------------
DROP TABLE IF EXISTS `character_visual_items`;
CREATE TABLE `character_visual_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `char_obj_id` int NOT NULL,
  `item_id` int NOT NULL,
  PRIMARY KEY (`id`, `char_obj_id`, `item_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;
