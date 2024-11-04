DROP TABLE IF EXISTS `character_collections`;
CREATE TABLE `character_collections` (
	`char_id` INT NOT NULL,
	`tab_id` SMALLINT UNSIGNED NOT NULL,
	`collection_id` INT UNSIGNED NOT NULL,
	`item_id` INT UNSIGNED NOT NULL,
	`slot_id` SMALLINT UNSIGNED NOT NULL
) ENGINE=MyISAM;