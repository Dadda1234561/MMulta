DROP TABLE IF EXISTS `character_mentoring`;
CREATE TABLE `character_mentoring` (
	`mentor` INT NOT NULL DEFAULT '0',
	`mentee` INT NOT NULL DEFAULT '0',
	PRIMARY KEY  (`mentor`,`mentee`)
) ENGINE=MyISAM;