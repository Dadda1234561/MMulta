DROP TABLE IF EXISTS `character_instance_resets`;
CREATE TABLE `character_instance_resets` (
  `char_id` int(11) NOT NULL,
  `instance_id` int(11) NOT NULL,
  `reset_cnt` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`char_id`,`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;