DROP TABLE IF EXISTS `chaos_festival_statistic`;
CREATE TABLE `chaos_festival_statistic` (
	`obj_id` INT NOT NULL DEFAULT '0',
	`points` BIGINT NOT NULL DEFAULT '0',
	PRIMARY KEY  (`obj_id`)
) ENGINE=MyISAM;
