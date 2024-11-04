DROP TABLE IF EXISTS `character_skiller_skills`;
CREATE TABLE `character_skiller_skills` (
  `char_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `profile_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `skill_id` int NOT NULL,
  `skill_lvl` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`char_id`,`profile_id`,`skill_id`,`skill_lvl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
