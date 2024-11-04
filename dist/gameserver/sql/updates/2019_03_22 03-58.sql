DROP TABLE IF EXISTS `character_monsterbook`;
CREATE TABLE `character_monsterbook` (
	`char_id` INT NOT NULL DEFAULT '0',
	`card_id` SMALLINT UNSIGNED NOT NULL DEFAULT '0',
	`kills` SMALLINT UNSIGNED NOT NULL DEFAULT '0',
	`level` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY  (`char_id`,`card_id`)
) ENGINE=MyISAM;