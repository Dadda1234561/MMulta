DROP TABLE IF EXISTS `character_healer_skills`;
CREATE TABLE `character_healer_skills` (
  `char_id` int NOT NULL,
  `skill_id` int NOT NULL,
  `skill_lvl` int NOT NULL,
  `skill_percent` int NOT NULL,
  PRIMARY KEY (`char_id`,`skill_id`,`skill_lvl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;