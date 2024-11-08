DROP TABLE IF EXISTS `heroes`;
CREATE TABLE `heroes` (
	`char_id` INT NOT NULL DEFAULT '0',
	`count` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	`played` TINYINT NOT NULL DEFAULT '0',
	`active` TINYINT NOT NULL DEFAULT '0',
	`message` varchar(300) NOT NULL default '',
	`legend_count` TINYINT UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY  (`char_id`)
) ENGINE=MyISAM;