﻿CREATE TABLE `groups` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL COMMENT 'group name',
	`flags` BIGINT UNSIGNED NOT NULL DEFAULT 0,
	`access` INT NOT NULL DEFAULT 0,
	`violation` INT NOT NULL DEFAULT 0,
	`maxdepotitems` INT NOT NULL,
	`maxviplist` INT NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

INSERT INTO `groups` (`id`, `name`, `flags`, `access`, `maxdepotitems`, `maxviplist`) VALUES
(1, 'player', 8796093022208, 0, 2000, 100),
(2, 'tutor', 8796109799424, 0, 2000, 100),
(3, 'senior tutor', 8796109832192, 0, 2000, 100),
(4, 'a gamemaster', 99505785405391, 2, 2000, 100),
(5, 'a community manager', 98406273884155, 3, 2000, 100),
(6, 'a god', 134140401786872, 4, 2000, 100);

CREATE TABLE `accounts` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`password` VARCHAR(255) NOT NULL/* VARCHAR(32) NOT NULL COMMENT 'MD5'*//* VARCHAR(40) NOT NULL COMMENT 'SHA1'*/,
	`email` VARCHAR(255) NOT NULL DEFAULT '',
	`premend` INT UNSIGNED NOT NULL DEFAULT 0,
	`blocked` TINYINT(1) NOT NULL DEFAULT FALSE,
	`warnings` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

INSERT INTO `accounts` (`id`, `password`, `email`, `premend`, `blocked`, `warnings`) VALUES
(1234567, 'tibia', 'nottinghster92@gmail.com', 0, 0, 0);

CREATE TABLE `players` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`account_id` INT UNSIGNED NOT NULL,
	`group_id` INT UNSIGNED NOT NULL COMMENT 'users group',
	`sex` INT UNSIGNED NOT NULL DEFAULT 0,
	`vocation` INT UNSIGNED NOT NULL DEFAULT 0,
	`experience` BIGINT UNSIGNED NOT NULL DEFAULT 0,
	`level` INT UNSIGNED NOT NULL DEFAULT 1,
	`maglevel` INT UNSIGNED NOT NULL DEFAULT 0,
	`health` INT NOT NULL DEFAULT 100,
	`healthmax` INT NOT NULL DEFAULT 100,
	`mana` INT NOT NULL DEFAULT 100,
	`manamax` INT NOT NULL DEFAULT 100,
	`manaspent` INT UNSIGNED NOT NULL DEFAULT 0,
	`soul` INT UNSIGNED NOT NULL DEFAULT 0,
	`direction` INT UNSIGNED NOT NULL DEFAULT 0,
	`lookbody` INT UNSIGNED NOT NULL DEFAULT 10,
	`lookfeet` INT UNSIGNED NOT NULL DEFAULT 10,
	`lookhead` INT UNSIGNED NOT NULL DEFAULT 10,
	`looklegs` INT UNSIGNED NOT NULL DEFAULT 10,
	`looktype` INT UNSIGNED NOT NULL DEFAULT 136,
	`lookaddons` INT UNSIGNED NOT NULL DEFAULT 0,
	`posx` INT NOT NULL DEFAULT 0,
	`posy` INT NOT NULL DEFAULT 0,
	`posz` INT NOT NULL DEFAULT 0,
	`cap` INT NOT NULL DEFAULT 0,
	`lastlogin` INT UNSIGNED NOT NULL DEFAULT 0,
	`lastlogout` INT UNSIGNED NOT NULL DEFAULT 0,
	`lastip` INT UNSIGNED NOT NULL DEFAULT 0,
	`save` TINYINT(1) NOT NULL DEFAULT TRUE,
	`conditions` BLOB NOT NULL COMMENT 'drunk, poisoned etc',
	`skull_type` INT NOT NULL DEFAULT 0,
	`skull_time` INT UNSIGNED NOT NULL DEFAULT 0,
	`loss_experience` INT NOT NULL DEFAULT 100,
	`loss_mana` INT NOT NULL DEFAULT 100,
	`loss_skills` INT NOT NULL DEFAULT 100,
	`loss_items` INT NOT NULL DEFAULT 10,
	`loss_containers` INT NOT NULL DEFAULT 100,
	`town_id` INT NOT NULL COMMENT 'old masterpos, temple spawn point position',
	`balance` INT NOT NULL DEFAULT 0 COMMENT 'money balance of the player for houses paying',
	`stamina` INT NOT NULL DEFAULT 151200000 COMMENT 'player stamina in milliseconds',
	`online` TINYINT(1) NOT NULL DEFAULT 0,
	`rank_id` INT NOT NULL COMMENT 'only if you use __OLD_GUILD_SYSTEM__',
	`guildnick` VARCHAR(255) NOT NULL COMMENT 'only if you use __OLD_GUILD_SYSTEM__',
	PRIMARY KEY (`id`),
	UNIQUE (`name`),
	KEY (`online`),
	FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE = InnoDB;

INSERT INTO `players` (`id`, `name`, `account_id`, `group_id`, `sex`, `vocation`, `experience`, `level`, `maglevel`, `health`, `healthmax`, `mana`, `manamax`, `manaspent`, `soul`, `direction`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `posx`, `posy`, `posz`, `cap`, `lastlogin`, `lastlogout`, `lastip`, `save`, `conditions`, `skull_type`, `skull_time`, `loss_experience`, `loss_mana`, `loss_skills`, `loss_items`, `loss_containers`, `town_id`, `balance`, `online`, `rank_id`, `guildnick`) VALUES
(1, 'Nottinghster', 1234567, 6, 1, 0, 100, 2, 4, 100, 100, 100, 100, 70775, 0, 2, 10, 10, 10, 10, 75, 32368, 32215, 7, 10000, 1396046551, 1396045859, 400558280, 1, '', 0, 0, 100, 100, 100, 10, 100, 11, 0, 0, 0, '');

CREATE TABLE `guilds` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`owner_id` INT UNSIGNED NOT NULL,
	`creationdate` INT NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE (`name`),
	FOREIGN KEY (`owner_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `guild_ranks` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`guild_id` INT UNSIGNED NOT NULL COMMENT 'guild',
	`name` VARCHAR(255) NOT NULL COMMENT 'rank name',
	`level` INT NOT NULL COMMENT 'rank level - leader, vice leader, member, maybe something else',
	PRIMARY KEY (`id`),
	FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `guild_members` (
	`player_id` INT UNSIGNED NOT NULL COMMENT 'if you doesnt use new guild system you are free to delete this table',
	`rank_id` INT UNSIGNED NOT NULL COMMENT 'a rank which belongs to certain guild',
	`nick` VARCHAR(255) NOT NULL DEFAULT '',
	UNIQUE (`player_id`),
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `guild_invites` (
	`player_id` INT NOT NULL DEFAULT 0,
	`guild_id` INT NOT NULL DEFAULT 0,
	UNIQUE (`player_id`, `guild_id`),
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE
) ENGINE = MyISAM;

CREATE TABLE `guild_kills` (
 	`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 	`guild_id` INT NOT NULL,
 	`war_id` INT NOT NULL,
 	`death_id` INT NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `player_viplist` (
	`player_id` INT UNSIGNED NOT NULL COMMENT 'id of player whose viplist entry it is',
	`vip_id` INT UNSIGNED NOT NULL COMMENT 'id of target player of viplist entry',
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`vip_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `player_spells` (
	`player_id` INT UNSIGNED NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `player_storage` (
	`player_id` INT UNSIGNED NOT NULL,
	`key` INT NOT NULL,
	`value` INT NOT NULL,
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `player_skills` (
	`player_id` INT UNSIGNED NOT NULL,
	`skillid` INT UNSIGNED NOT NULL,
	`value` INT UNSIGNED NOT NULL DEFAULT 0,
	`count` INT UNSIGNED NOT NULL DEFAULT 0,
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

INSERT INTO `player_skills` (`player_id`, `skillid`, `value`, `count`) VALUES
(1, 0, 10, 0),
(1, 1, 10, 0),
(1, 2, 10, 0),
(1, 3, 10, 0),
(1, 4, 10, 0),
(1, 5, 10, 0),
(1, 6, 10, 0);

CREATE TABLE `player_items` (
	`player_id` INT UNSIGNED NOT NULL,
	`sid` INT NOT NULL,
	`pid` INT NOT NULL DEFAULT 0,
	`itemtype` INT NOT NULL,
	`count` INT NOT NULL DEFAULT 0,
	`attributes` BLOB COMMENT 'replaces unique_id, action_id, text, special_desc',
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
	UNIQUE (`player_id`, `sid`)
) ENGINE = InnoDB;

CREATE TABLE `houses` (
	`id` INT UNSIGNED NOT NULL,
	`townid` INT UNSIGNED NOT NULL DEFAULT 0,
	`name` VARCHAR(100) NOT NULL,
	`rent` INT UNSIGNED NOT NULL DEFAULT 0,
	`guildhall` TINYINT(1) NOT NULL DEFAULT 0,
	`tiles` INT UNSIGNED NOT NULL DEFAULT 0,
	`doors` INT UNSIGNED NOT NULL DEFAULT 0,
	`beds` INT UNSIGNED NOT NULL DEFAULT 0,
	`owner` INT NOT NULL DEFAULT 0,
	`paid` INT UNSIGNED NOT NULL DEFAULT 0,
	`clear` TINYINT(1) NOT NULL DEFAULT 0,
	`warnings` INT NOT NULL DEFAULT 0,
	`lastwarning` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE `house_auctions` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`house_id` INT UNSIGNED NOT NULL,
	`player_id` INT UNSIGNED NOT NULL,
	`bid` INT UNSIGNED NOT NULL DEFAULT 0,
	`limit` INT UNSIGNED NOT NULL DEFAULT 0,
	`endtime` INT UNSIGNED NOT NULL DEFAULT 0,
	FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE `house_lists` (
	`house_id` INT UNSIGNED NOT NULL,
	`listid` INT NOT NULL,
	`list` TEXT NOT NULL,
	FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `bans` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`type` INT NOT NULL COMMENT 'this field defines if its ip, account, player, or any else ban',
	`value` INT UNSIGNED NOT NULL COMMENT 'ip, player guid, account number',
	`param` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'mask',
	`active` TINYINT(1) NOT NULL DEFAULT TRUE,
	`expires` INT NOT NULL,
	`added` INT UNSIGNED NOT NULL,
	`admin_id` INT UNSIGNED,
	`comment` VARCHAR(1024) NOT NULL DEFAULT '',
	`reason` INT UNSIGNED NOT NULL DEFAULT 0,
	`action` INT UNSIGNED NOT NULL DEFAULT 0,
	`statement` VARCHAR(255) NOT NULL DEFAULT '',
	PRIMARY KEY  (`id`),
	KEY (`type`, `value`),
	KEY (`expires`),
	FOREIGN KEY (`admin_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE `tiles` (
	`id` INT UNSIGNED NOT NULL,
	`house_id` INT UNSIGNED NOT NULL DEFAULT 0,
	`x` INT(5) UNSIGNED NOT NULL,
	`y` INT(5) UNSIGNED NOT NULL,
	`z` INT(2) UNSIGNED NOT NULL,
	PRIMARY KEY(`id`),
	KEY(`x`, `y`, `z`),
	FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE `tile_items` (
	`tile_id` INT UNSIGNED NOT NULL,
	`sid` INT NOT NULL,
	`pid` INT NOT NULL DEFAULT 0,
	`itemtype` INT NOT NULL,
	`count` INT NOT NULL DEFAULT 0,
	`attributes` BLOB NOT NULL,
	INDEX (`sid`),
	FOREIGN KEY (`tile_id`) REFERENCES `tiles` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `map_store` (
	`house_id` INT UNSIGNED NOT NULL,
	`data` LONGBLOB NOT NULL,
	KEY(`house_id`)
) ENGINE = InnoDB;

CREATE TABLE `player_deaths` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`player_id` INT UNSIGNED NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	`level` INT NOT NULL,
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
	PRIMARY KEY(`id`),
	INDEX(`date`)
) ENGINE = InnoDB;

CREATE TABLE `killers` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`death_id` INT UNSIGNED NOT NULL,
	`final_hit` TINYINT(1) NOT NULL DEFAULT 1,
	`war` INT NOT NULL DEFAULT 0,
	PRIMARY KEY(`id`),
	FOREIGN KEY (`death_id`) REFERENCES `player_deaths` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `environment_killers` (
	`kill_id` INT UNSIGNED NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`kill_id`, `name`),
	FOREIGN KEY (`kill_id`) REFERENCES `killers` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `player_killers` (
	`kill_id` INT UNSIGNED NOT NULL,
	`player_id` INT UNSIGNED NOT NULL,
	`unjustified` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`kill_id`, `player_id`),
	FOREIGN KEY (`kill_id`) REFERENCES `killers` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `player_depotitems` (
	`player_id` INT UNSIGNED NOT NULL,
	`sid` INT NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
	`pid` INT NOT NULL DEFAULT 0,
	`itemtype` INT NOT NULL,
	`count` INT NOT NULL DEFAULT 0,
	`attributes` BLOB NOT NULL,
	FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
	UNIQUE (`player_id`, `sid`)
) ENGINE = InnoDB;

CREATE TABLE `global_storage` (
	`key` INT UNSIGNED NOT NULL,
	`value` INT NOT NULL,
	PRIMARY KEY(`key`)
) ENGINE = InnoDB;

CREATE TABLE `schema_info` (
	`name` VARCHAR(255) NOT NULL,
	`value` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`name`)
) ENGINE = InnoDB;

INSERT INTO `schema_info` (`name`, `value`) VALUES ('version', 25);
DELIMITER |

CREATE TRIGGER `ondelete_accounts`
BEFORE DELETE
ON `accounts`
FOR EACH ROW
BEGIN
	DELETE FROM `bans` WHERE `type` = 3 AND `value` = OLD.`id`;
END|

CREATE TRIGGER `ondelete_players`
BEFORE DELETE
ON `players`
FOR EACH ROW
BEGIN
	DELETE FROM `bans` WHERE `type` = 2 AND `value` = OLD.`id`;
	UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END|

CREATE TRIGGER `oncreate_guilds`
AFTER INSERT
ON `guilds`
FOR EACH ROW
BEGIN
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Leader', 3, NEW.`id`);
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Vice-Leader', 2, NEW.`id`);
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Member', 1, NEW.`id`);
END|

CREATE TRIGGER `oncreate_players`
AFTER INSERT
ON `players`
FOR EACH ROW
BEGIN
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 0, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 1, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 2, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 3, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 4, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 5, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 6, 10);
END|

DELIMITER ;