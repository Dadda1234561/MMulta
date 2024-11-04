DROP TABLE IF EXISTS `character_factions`;
CREATE TABLE `character_factions` (
	`char_id` INT NOT NULL,
	`type` TINYINT NOT NULL,
	`progress` INT NOT NULL DEFAULT '0',
	PRIMARY KEY  (`char_id`,`type`)
) ENGINE=MyISAM;
