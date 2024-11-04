ALTER TABLE clan_data ADD COLUMN `name` VARCHAR(45) CHARACTER SET UTF8 NOT NULL DEFAULT '' AFTER `clan_id`;
ALTER TABLE clan_data ADD COLUMN `leader_id` INT UNSIGNED NOT NULL DEFAULT '0' AFTER `name`;
UPDATE clan_data LEFT JOIN clan_subpledges ON clan_subpledges.clan_id=clan_data.clan_id AND clan_subpledges.type=0 SET clan_data.name=clan_subpledges.name, clan_data.leader_id=clan_subpledges.leader_id;
DROP TABLE clan_subpledges;