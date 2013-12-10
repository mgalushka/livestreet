-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.24-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             8.1.0.4545
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table livestreet.ls_blog
DROP TABLE IF EXISTS `ls_blog`;
CREATE TABLE IF NOT EXISTS `ls_blog` (
  `blog_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_owner_id` int(11) unsigned NOT NULL,
  `blog_title` varchar(200) NOT NULL,
  `blog_description` text NOT NULL,
  `blog_type` enum('personal','open','invite','close') DEFAULT 'personal',
  `blog_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'mgalushka: flag determines if blog is default to post all messages to it.',
  `blog_date_add` datetime NOT NULL,
  `blog_date_edit` datetime DEFAULT NULL,
  `blog_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `blog_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `blog_count_user` int(11) unsigned NOT NULL DEFAULT '0',
  `blog_count_topic` int(10) unsigned NOT NULL DEFAULT '0',
  `blog_limit_rating_topic` float(9,3) NOT NULL DEFAULT '0.000',
  `blog_url` varchar(200) DEFAULT NULL,
  `blog_avatar` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`blog_id`),
  KEY `user_owner_id` (`user_owner_id`),
  KEY `blog_type` (`blog_type`),
  KEY `blog_url` (`blog_url`),
  KEY `blog_title` (`blog_title`),
  KEY `blog_count_topic` (`blog_count_topic`),
  CONSTRAINT `ls_blog_fk` FOREIGN KEY (`user_owner_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_blog: ~3 rows (approximately)
/*!40000 ALTER TABLE `ls_blog` DISABLE KEYS */;
INSERT INTO `ls_blog` (`blog_id`, `user_owner_id`, `blog_title`, `blog_description`, `blog_type`, `blog_default`, `blog_date_add`, `blog_date_edit`, `blog_rating`, `blog_count_vote`, `blog_count_user`, `blog_count_topic`, `blog_limit_rating_topic`, `blog_url`, `blog_avatar`) VALUES
	(1, 1, 'Наші рішення', 'Опублікуйте своє рішення спільної проблеми.', 'personal', 0, '2012-08-07 00:00:00', NULL, 0.000, 0, 0, 0, -1000.000, NULL, '0'),
	(2, 2, 'Наші рішення', 'Опублікуйте своє рішення спільної проблеми.', 'personal', 0, '2013-12-09 16:20:57', NULL, 0.000, 0, 0, 2, -1000.000, NULL, NULL),
	(3, 1, 'Публікації', 'Публікуйте свої пропозиції сюди.', 'open', 1, '2013-12-10 18:20:12', '2013-12-10 18:35:27', 0.000, 0, 1, 0, -10.000, 'publications', NULL),
	(4, 1, 'just new blog from admin', 'ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss', 'close', 0, '2013-12-10 19:19:57', NULL, 0.000, 0, 0, 0, 1000.000, 'newblogtest', NULL);
/*!40000 ALTER TABLE `ls_blog` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_blog_user
DROP TABLE IF EXISTS `ls_blog_user`;
CREATE TABLE IF NOT EXISTS `ls_blog_user` (
  `blog_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `user_role` int(3) DEFAULT '1',
  UNIQUE KEY `blog_id_user_id_uniq` (`blog_id`,`user_id`),
  KEY `blog_id` (`blog_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ls_blog_user_fk` FOREIGN KEY (`blog_id`) REFERENCES `ls_blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_blog_user_fk1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_blog_user: ~1 rows (approximately)
/*!40000 ALTER TABLE `ls_blog_user` DISABLE KEYS */;
INSERT INTO `ls_blog_user` (`blog_id`, `user_id`, `user_role`) VALUES
	(3, 2, 1);
/*!40000 ALTER TABLE `ls_blog_user` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_comment
DROP TABLE IF EXISTS `ls_comment`;
CREATE TABLE IF NOT EXISTS `ls_comment` (
  `comment_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `comment_pid` int(11) unsigned DEFAULT NULL,
  `comment_left` int(11) NOT NULL DEFAULT '0',
  `comment_right` int(11) NOT NULL DEFAULT '0',
  `comment_level` int(11) NOT NULL DEFAULT '0',
  `target_id` int(11) unsigned DEFAULT NULL,
  `target_type` enum('topic','talk') NOT NULL DEFAULT 'topic',
  `target_parent_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) unsigned NOT NULL,
  `comment_text` text NOT NULL,
  `comment_text_hash` varchar(32) NOT NULL,
  `comment_date` datetime NOT NULL,
  `comment_user_ip` varchar(20) NOT NULL,
  `comment_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `comment_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `comment_count_favourite` int(11) unsigned NOT NULL DEFAULT '0',
  `comment_delete` tinyint(4) NOT NULL DEFAULT '0',
  `comment_publish` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`comment_id`),
  KEY `comment_pid` (`comment_pid`),
  KEY `type_date_rating` (`target_type`,`comment_date`,`comment_rating`),
  KEY `id_type` (`target_id`,`target_type`),
  KEY `type_delete_publish` (`target_type`,`comment_delete`,`comment_publish`),
  KEY `user_type` (`user_id`,`target_type`),
  KEY `target_parent_id` (`target_parent_id`),
  KEY `comment_left` (`comment_left`),
  KEY `comment_right` (`comment_right`),
  KEY `comment_level` (`comment_level`),
  CONSTRAINT `ls_topic_comment_fk` FOREIGN KEY (`comment_pid`) REFERENCES `ls_comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `topic_comment_fk1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_comment: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_comment` DISABLE KEYS */;
INSERT INTO `ls_comment` (`comment_id`, `comment_pid`, `comment_left`, `comment_right`, `comment_level`, `target_id`, `target_type`, `target_parent_id`, `user_id`, `comment_text`, `comment_text_hash`, `comment_date`, `comment_user_ip`, `comment_rating`, `comment_count_vote`, `comment_count_favourite`, `comment_delete`, `comment_publish`) VALUES
	(1, NULL, 0, 0, 0, 3, 'topic', 2, 2, 'sadasd', 'c99a11a53a3748269e3f86d7ac38df11', '2013-12-10 18:59:09', '127.0.0.1', 0.000, 0, 0, 0, 1),
	(2, NULL, 0, 0, 0, 3, 'topic', 2, 1, 'test', '098f6bcd4621d373cade4e832627b4f6', '2013-12-10 19:00:22', '127.0.0.1', 0.000, 0, 0, 0, 1),
	(3, NULL, 0, 0, 0, 2, 'topic', 2, 2, 'ываываыва', 'ea4af0e5366e98982b518c00f3350d28', '2013-12-10 19:02:23', '127.0.0.1', 0.000, 0, 0, 0, 1);
/*!40000 ALTER TABLE `ls_comment` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_comment_moderation
DROP TABLE IF EXISTS `ls_comment_moderation`;
CREATE TABLE IF NOT EXISTS `ls_comment_moderation` (
  `comment_id` int(10) unsigned NOT NULL,
  `comment_author` int(10) unsigned NOT NULL,
  `blog_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `comment_author` (`comment_author`),
  KEY `blog_id` (`blog_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_comment_moderation: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_comment_moderation` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_comment_moderation` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_comment_online
DROP TABLE IF EXISTS `ls_comment_online`;
CREATE TABLE IF NOT EXISTS `ls_comment_online` (
  `comment_online_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `target_id` int(11) unsigned DEFAULT NULL,
  `target_type` enum('topic','talk') NOT NULL DEFAULT 'topic',
  `target_parent_id` int(11) NOT NULL DEFAULT '0',
  `comment_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`comment_online_id`),
  UNIQUE KEY `id_type` (`target_id`,`target_type`),
  KEY `comment_id` (`comment_id`),
  KEY `type_parent` (`target_type`,`target_parent_id`),
  CONSTRAINT `ls_topic_comment_online_fk1` FOREIGN KEY (`comment_id`) REFERENCES `ls_comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_comment_online: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_comment_online` DISABLE KEYS */;
INSERT INTO `ls_comment_online` (`comment_online_id`, `target_id`, `target_type`, `target_parent_id`, `comment_id`) VALUES
	(2, 3, 'topic', 2, 2),
	(3, 2, 'topic', 2, 3);
/*!40000 ALTER TABLE `ls_comment_online` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_favourite
DROP TABLE IF EXISTS `ls_favourite`;
CREATE TABLE IF NOT EXISTS `ls_favourite` (
  `user_id` int(11) unsigned NOT NULL,
  `target_id` int(11) unsigned DEFAULT NULL,
  `target_type` enum('topic','comment','talk') DEFAULT 'topic',
  `target_publish` tinyint(1) DEFAULT '1',
  `tags` varchar(250) NOT NULL,
  UNIQUE KEY `user_id_target_id_type` (`user_id`,`target_id`,`target_type`),
  KEY `target_publish` (`target_publish`),
  KEY `id_type` (`target_id`,`target_type`),
  CONSTRAINT `ls_favourite_target_fk` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_favourite: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_favourite` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_favourite` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_favourite_tag
DROP TABLE IF EXISTS `ls_favourite_tag`;
CREATE TABLE IF NOT EXISTS `ls_favourite_tag` (
  `user_id` int(10) unsigned NOT NULL,
  `target_id` int(11) NOT NULL,
  `target_type` enum('topic','comment','talk') NOT NULL,
  `is_user` tinyint(1) NOT NULL DEFAULT '0',
  `text` varchar(50) NOT NULL,
  KEY `user_id_target_type_id` (`user_id`,`target_type`,`target_id`),
  KEY `target_type_id` (`target_type`,`target_id`),
  KEY `is_user` (`is_user`),
  KEY `text` (`text`),
  CONSTRAINT `ls_favourite_tag_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_favourite_tag: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_favourite_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_favourite_tag` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_friend
DROP TABLE IF EXISTS `ls_friend`;
CREATE TABLE IF NOT EXISTS `ls_friend` (
  `user_from` int(11) unsigned NOT NULL DEFAULT '0',
  `user_to` int(11) unsigned NOT NULL DEFAULT '0',
  `status_from` int(4) NOT NULL,
  `status_to` int(4) NOT NULL,
  PRIMARY KEY (`user_from`,`user_to`),
  KEY `user_to` (`user_to`),
  CONSTRAINT `ls_friend_from_fk` FOREIGN KEY (`user_from`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_friend_to_fk` FOREIGN KEY (`user_to`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_friend: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_friend` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_friend` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_geo_city
DROP TABLE IF EXISTS `ls_geo_city`;
CREATE TABLE IF NOT EXISTS `ls_geo_city` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country_id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  `name_ru` varchar(50) NOT NULL,
  `name_en` varchar(50) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sort` (`sort`),
  KEY `country_id` (`country_id`),
  KEY `region_id` (`region_id`),
  KEY `name_ru` (`name_ru`),
  KEY `name_en` (`name_en`),
  CONSTRAINT `ls_geo_city_ibfk_2` FOREIGN KEY (`region_id`) REFERENCES `ls_geo_region` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_geo_city_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `ls_geo_country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17590 DEFAULT CHARSET=utf8;


-- Dumping structure for table livestreet.ls_geo_country
DROP TABLE IF EXISTS `ls_geo_country`;
CREATE TABLE IF NOT EXISTS `ls_geo_country` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_ru` varchar(50) NOT NULL,
  `name_en` varchar(50) NOT NULL,
  `code` varchar(5) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sort` (`sort`),
  KEY `name_ru` (`name_ru`),
  KEY `name_en` (`name_en`),
  KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8;


-- Dumping structure for table livestreet.ls_geo_region
DROP TABLE IF EXISTS `ls_geo_region`;
CREATE TABLE IF NOT EXISTS `ls_geo_region` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country_id` int(11) NOT NULL,
  `name_ru` varchar(50) NOT NULL,
  `name_en` varchar(50) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sort` (`sort`),
  KEY `country_id` (`country_id`),
  KEY `name_ru` (`name_ru`),
  KEY `name_en` (`name_en`),
  CONSTRAINT `ls_geo_region_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `ls_geo_country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1612 DEFAULT CHARSET=utf8;


-- Dumping structure for table livestreet.ls_geo_target
DROP TABLE IF EXISTS `ls_geo_target`;
CREATE TABLE IF NOT EXISTS `ls_geo_target` (
  `geo_type` varchar(20) NOT NULL,
  `geo_id` int(11) NOT NULL,
  `target_type` varchar(20) NOT NULL,
  `target_id` int(11) NOT NULL,
  `country_id` int(11) DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`geo_type`,`geo_id`,`target_type`,`target_id`),
  KEY `target_type` (`target_type`,`target_id`),
  KEY `country_id` (`country_id`),
  KEY `region_id` (`region_id`),
  KEY `city_id` (`city_id`),
  CONSTRAINT `ls_geo_target_ibfk_3` FOREIGN KEY (`city_id`) REFERENCES `ls_geo_city` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_geo_target_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `ls_geo_country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_geo_target_ibfk_2` FOREIGN KEY (`region_id`) REFERENCES `ls_geo_region` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_geo_target: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_geo_target` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_geo_target` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_invite
DROP TABLE IF EXISTS `ls_invite`;
CREATE TABLE IF NOT EXISTS `ls_invite` (
  `invite_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `invite_code` varchar(32) NOT NULL,
  `user_from_id` int(11) unsigned NOT NULL,
  `user_to_id` int(11) unsigned DEFAULT NULL,
  `invite_date_add` datetime NOT NULL,
  `invite_date_used` datetime DEFAULT NULL,
  `invite_used` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`invite_id`),
  UNIQUE KEY `invite_code` (`invite_code`),
  KEY `user_from_id` (`user_from_id`),
  KEY `user_to_id` (`user_to_id`),
  KEY `invite_date_add` (`invite_date_add`),
  CONSTRAINT `ls_invite_fk` FOREIGN KEY (`user_from_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_invite_fk1` FOREIGN KEY (`user_to_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_invite: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_invite` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_invite` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_notify_task
DROP TABLE IF EXISTS `ls_notify_task`;
CREATE TABLE IF NOT EXISTS `ls_notify_task` (
  `notify_task_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(30) DEFAULT NULL,
  `user_mail` varchar(50) DEFAULT NULL,
  `notify_subject` varchar(200) DEFAULT NULL,
  `notify_text` text,
  `date_created` datetime DEFAULT NULL,
  `notify_task_status` tinyint(2) unsigned DEFAULT NULL,
  PRIMARY KEY (`notify_task_id`),
  KEY `date_created` (`date_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_notify_task: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_notify_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_notify_task` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_reminder
DROP TABLE IF EXISTS `ls_reminder`;
CREATE TABLE IF NOT EXISTS `ls_reminder` (
  `reminder_code` varchar(32) NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `reminder_date_add` datetime NOT NULL,
  `reminder_date_used` datetime DEFAULT '0000-00-00 00:00:00',
  `reminder_date_expire` datetime NOT NULL,
  `reminde_is_used` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`reminder_code`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `ls_reminder_fk` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_reminder: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_reminder` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_reminder` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_session
DROP TABLE IF EXISTS `ls_session`;
CREATE TABLE IF NOT EXISTS `ls_session` (
  `session_key` varchar(32) NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `session_ip_create` varchar(15) NOT NULL,
  `session_ip_last` varchar(15) NOT NULL,
  `session_date_create` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `session_date_last` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `session_date_last` (`session_date_last`),
  CONSTRAINT `ls_session_fk` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_session: ~2 rows (approximately)
/*!40000 ALTER TABLE `ls_session` DISABLE KEYS */;
INSERT INTO `ls_session` (`session_key`, `user_id`, `session_ip_create`, `session_ip_last`, `session_date_create`, `session_date_last`) VALUES
	('87bbd49317b4e435d05913a1816df3fb', 2, '127.0.0.1', '127.0.0.1', '2013-12-10 18:34:50', '2013-12-10 19:20:40'),
	('ded38c59842078a7a409b789415842ad', 1, '127.0.0.1', '127.0.0.1', '2013-12-09 20:17:20', '2013-12-10 19:31:19');
/*!40000 ALTER TABLE `ls_session` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_stream_event
DROP TABLE IF EXISTS `ls_stream_event`;
CREATE TABLE IF NOT EXISTS `ls_stream_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type` varchar(100) NOT NULL,
  `target_id` int(11) NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `publish` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `event_type` (`event_type`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `publish` (`publish`),
  KEY `target_id` (`target_id`),
  CONSTRAINT `ls_stream_event_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_stream_event: ~2 rows (approximately)
/*!40000 ALTER TABLE `ls_stream_event` DISABLE KEYS */;
INSERT INTO `ls_stream_event` (`id`, `event_type`, `target_id`, `user_id`, `date_added`, `publish`) VALUES
	(1, 'add_blog', 3, 1, '2013-12-10 18:20:13', 1),
	(2, 'join_blog', 3, 2, '2013-12-10 18:35:27', 1),
	(3, 'add_comment', 1, 2, '2013-12-10 18:59:09', 1),
	(4, 'add_topic', 2, 2, '2013-12-10 19:00:11', 1),
	(5, 'add_comment', 2, 1, '2013-12-10 19:00:24', 1),
	(6, 'add_topic', 3, 2, '2013-12-10 19:02:08', 1),
	(7, 'add_comment', 3, 2, '2013-12-10 19:02:23', 1),
	(8, 'add_blog', 4, 1, '2013-12-10 19:19:57', 1);
/*!40000 ALTER TABLE `ls_stream_event` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_stream_subscribe
DROP TABLE IF EXISTS `ls_stream_subscribe`;
CREATE TABLE IF NOT EXISTS `ls_stream_subscribe` (
  `user_id` int(11) unsigned NOT NULL,
  `target_user_id` int(11) NOT NULL,
  KEY `user_id` (`user_id`,`target_user_id`),
  CONSTRAINT `ls_stream_subscribe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_stream_subscribe: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_stream_subscribe` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_stream_subscribe` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_stream_user_type
DROP TABLE IF EXISTS `ls_stream_user_type`;
CREATE TABLE IF NOT EXISTS `ls_stream_user_type` (
  `user_id` int(11) unsigned NOT NULL,
  `event_type` varchar(100) DEFAULT NULL,
  KEY `user_id` (`user_id`,`event_type`),
  CONSTRAINT `ls_stream_user_type_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_stream_user_type: ~6 rows (approximately)
/*!40000 ALTER TABLE `ls_stream_user_type` DISABLE KEYS */;
INSERT INTO `ls_stream_user_type` (`user_id`, `event_type`) VALUES
	(2, 'add_blog'),
	(2, 'add_comment'),
	(2, 'add_friend'),
	(2, 'add_topic'),
	(2, 'add_wall'),
	(2, 'vote_topic');
/*!40000 ALTER TABLE `ls_stream_user_type` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_subscribe
DROP TABLE IF EXISTS `ls_subscribe`;
CREATE TABLE IF NOT EXISTS `ls_subscribe` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_type` varchar(20) NOT NULL,
  `target_id` int(11) DEFAULT NULL,
  `mail` varchar(50) NOT NULL,
  `date_add` datetime NOT NULL,
  `date_remove` datetime DEFAULT NULL,
  `ip` varchar(20) NOT NULL,
  `key` varchar(32) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `type` (`target_type`),
  KEY `mail` (`mail`),
  KEY `status` (`status`),
  KEY `key` (`key`),
  KEY `target_id` (`target_id`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_subscribe: ~1 rows (approximately)
/*!40000 ALTER TABLE `ls_subscribe` DISABLE KEYS */;
INSERT INTO `ls_subscribe` (`id`, `target_type`, `target_id`, `mail`, `date_add`, `date_remove`, `ip`, `key`, `status`) VALUES
	(1, 'topic_new_comment', 1, 'max@mail.ru', '2013-12-10 17:42:11', NULL, '127.0.0.1', '0b3a585c192d484c441c5157daac856b', 1),
	(2, 'topic_new_comment', 2, 'max@mail.ru', '2013-12-10 18:55:52', NULL, '127.0.0.1', 'bd3769f6d8abeeaad60dd1247aff6d4d', 1),
	(3, 'topic_new_comment', 3, 'max@mail.ru', '2013-12-10 18:59:02', NULL, '127.0.0.1', '9c9d593b630dc4321f966490df64cb2f', 1);
/*!40000 ALTER TABLE `ls_subscribe` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_talk
DROP TABLE IF EXISTS `ls_talk`;
CREATE TABLE IF NOT EXISTS `ls_talk` (
  `talk_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `talk_title` varchar(200) NOT NULL,
  `talk_text` text NOT NULL,
  `talk_date` datetime NOT NULL,
  `talk_date_last` datetime NOT NULL,
  `talk_user_id_last` int(11) NOT NULL,
  `talk_user_ip` varchar(20) NOT NULL,
  `talk_comment_id_last` int(11) DEFAULT NULL,
  `talk_count_comment` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`talk_id`),
  KEY `user_id` (`user_id`),
  KEY `talk_title` (`talk_title`),
  KEY `talk_date` (`talk_date`),
  KEY `talk_date_last` (`talk_date_last`),
  KEY `talk_user_id_last` (`talk_user_id_last`),
  CONSTRAINT `ls_talk_fk` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_talk: ~1 rows (approximately)
/*!40000 ALTER TABLE `ls_talk` DISABLE KEYS */;
INSERT INTO `ls_talk` (`talk_id`, `user_id`, `talk_title`, `talk_text`, `talk_date`, `talk_date_last`, `talk_user_id_last`, `talk_user_ip`, `talk_comment_id_last`, `talk_count_comment`) VALUES
	(1, 2, 'NOT_FOUND_LANG_TEXT', 'NOT_FOUND_LANG_TEXT<a href=\'http://localhost/livestreet/blog/1.html\'>премодерация</a>', '2013-12-10 17:42:09', '2013-12-10 17:42:09', 2, '127.0.0.1', NULL, 0),
	(2, 2, 'Нова публікація на модерації', 'На модерацяю надійшла нова публікація. Будь ласка, ознайомтесь: <a href=\'http://localhost/livestreet/blog/2.html\'>First user test</a>', '2013-12-10 18:55:51', '2013-12-10 18:55:51', 2, '127.0.0.1', NULL, 0),
	(3, 2, 'Нова публікація на модерації', 'На модерацяю надійшла нова публікація. Будь ласка, ознайомтесь: <a href=\'http://localhost/livestreet/blog/3.html\'>Моя думка 2</a>', '2013-12-10 18:59:00', '2013-12-10 18:59:00', 2, '127.0.0.1', NULL, 0),
	(4, 2, 'Нова публікація на модерації', 'На модерацяю надійшла нова публікація. Будь ласка, ознайомтесь: <a href=\'http://localhost/livestreet/blog/2.html\'>First user test</a>', '2013-12-10 19:01:57', '2013-12-10 19:01:57', 2, '127.0.0.1', NULL, 0);
/*!40000 ALTER TABLE `ls_talk` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_talk_blacklist
DROP TABLE IF EXISTS `ls_talk_blacklist`;
CREATE TABLE IF NOT EXISTS `ls_talk_blacklist` (
  `user_id` int(10) unsigned NOT NULL,
  `user_target_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`user_target_id`),
  KEY `ls_talk_blacklist_fk_target` (`user_target_id`),
  CONSTRAINT `ls_talk_blacklist_fk_target` FOREIGN KEY (`user_target_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_talk_blacklist_fk_user` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_talk_blacklist: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_talk_blacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_talk_blacklist` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_talk_user
DROP TABLE IF EXISTS `ls_talk_user`;
CREATE TABLE IF NOT EXISTS `ls_talk_user` (
  `talk_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date_last` datetime DEFAULT NULL,
  `comment_id_last` int(11) NOT NULL DEFAULT '0',
  `comment_count_new` int(11) NOT NULL DEFAULT '0',
  `talk_user_active` tinyint(1) DEFAULT '1',
  UNIQUE KEY `talk_id_user_id` (`talk_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `date_last` (`date_last`),
  KEY `date_last_2` (`date_last`),
  KEY `talk_user_active` (`talk_user_active`),
  KEY `comment_count_new` (`comment_count_new`),
  CONSTRAINT `ls_talk_user_fk` FOREIGN KEY (`talk_id`) REFERENCES `ls_talk` (`talk_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_talk_user_fk1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_talk_user: ~2 rows (approximately)
/*!40000 ALTER TABLE `ls_talk_user` DISABLE KEYS */;
INSERT INTO `ls_talk_user` (`talk_id`, `user_id`, `date_last`, `comment_id_last`, `comment_count_new`, `talk_user_active`) VALUES
	(1, 1, '2013-12-10 17:47:38', 0, 0, 1),
	(1, 2, '2013-12-10 17:48:23', 0, 0, 1),
	(2, 1, '2013-12-10 18:56:04', 0, 0, 1),
	(2, 2, '2013-12-10 18:55:51', 0, 0, 1),
	(3, 1, NULL, 0, 0, 1),
	(3, 2, '2013-12-10 18:59:00', 0, 0, 1),
	(4, 1, NULL, 0, 0, 1),
	(4, 2, '2013-12-10 19:01:57', 0, 0, 1);
/*!40000 ALTER TABLE `ls_talk_user` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_topic
DROP TABLE IF EXISTS `ls_topic`;
CREATE TABLE IF NOT EXISTS `ls_topic` (
  `topic_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blog_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `topic_type` enum('topic','link','question','photoset') NOT NULL DEFAULT 'topic',
  `topic_title` varchar(200) NOT NULL,
  `topic_tags` varchar(250) NOT NULL COMMENT 'tags separated by a comma',
  `topic_date_add` datetime NOT NULL,
  `topic_date_edit` datetime DEFAULT NULL,
  `topic_user_ip` varchar(20) NOT NULL,
  `topic_publish` tinyint(1) NOT NULL DEFAULT '0',
  `topic_publish_draft` tinyint(1) NOT NULL DEFAULT '1',
  `topic_publish_index` tinyint(1) NOT NULL DEFAULT '0',
  `topic_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `topic_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_count_vote_up` int(11) NOT NULL DEFAULT '0',
  `topic_count_vote_down` int(11) NOT NULL DEFAULT '0',
  `topic_count_vote_abstain` int(11) NOT NULL DEFAULT '0',
  `topic_count_read` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_count_comment` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_count_favourite` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_cut_text` varchar(100) DEFAULT NULL,
  `topic_forbid_comment` tinyint(1) NOT NULL DEFAULT '0',
  `topic_text_hash` varchar(32) NOT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `blog_id` (`blog_id`),
  KEY `user_id` (`user_id`),
  KEY `topic_date_add` (`topic_date_add`),
  KEY `topic_rating` (`topic_rating`),
  KEY `topic_publish` (`topic_publish`),
  KEY `topic_text_hash` (`topic_text_hash`),
  KEY `topic_count_comment` (`topic_count_comment`),
  CONSTRAINT `ls_topic_fk` FOREIGN KEY (`blog_id`) REFERENCES `ls_blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_topic_fk1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_topic: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_topic` DISABLE KEYS */;
INSERT INTO `ls_topic` (`topic_id`, `blog_id`, `user_id`, `topic_type`, `topic_title`, `topic_tags`, `topic_date_add`, `topic_date_edit`, `topic_user_ip`, `topic_publish`, `topic_publish_draft`, `topic_publish_index`, `topic_rating`, `topic_count_vote`, `topic_count_vote_up`, `topic_count_vote_down`, `topic_count_vote_abstain`, `topic_count_read`, `topic_count_comment`, `topic_count_favourite`, `topic_cut_text`, `topic_forbid_comment`, `topic_text_hash`) VALUES
	(2, 2, 2, 'topic', 'First user test', 'First user test', '2013-12-10 19:00:10', '2013-12-10 19:01:57', '127.0.0.1', 1, 1, 0, 0.000, 0, 0, 0, 0, 0, 1, 0, NULL, 0, '5e34e2c581a3af61d8c9d9b8d5170b13'),
	(3, 2, 2, 'topic', 'Моя думка 2', 'dumka', '2013-12-10 19:02:08', '2013-12-10 19:02:08', '127.0.0.1', 1, 1, 0, 0.000, 0, 0, 0, 0, 0, 2, 0, NULL, 0, 'cc6c546fcb2a1ac5037e628fcb53dbbd');
/*!40000 ALTER TABLE `ls_topic` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_topic_content
DROP TABLE IF EXISTS `ls_topic_content`;
CREATE TABLE IF NOT EXISTS `ls_topic_content` (
  `topic_id` int(11) unsigned NOT NULL,
  `topic_text` longtext NOT NULL,
  `topic_text_short` text NOT NULL,
  `topic_text_source` longtext NOT NULL,
  `topic_extra` text NOT NULL,
  PRIMARY KEY (`topic_id`),
  CONSTRAINT `ls_topic_content_fk` FOREIGN KEY (`topic_id`) REFERENCES `ls_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_topic_content: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_topic_content` DISABLE KEYS */;
INSERT INTO `ls_topic_content` (`topic_id`, `topic_text`, `topic_text_short`, `topic_text_source`, `topic_extra`) VALUES
	(2, 'First user test', 'First user test', 'First user test', 's:0:"";'),
	(3, 'Моя думка 2', 'Моя думка 2', 'Моя думка 2', 's:0:"";');
/*!40000 ALTER TABLE `ls_topic_content` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_topic_moderation
DROP TABLE IF EXISTS `ls_topic_moderation`;
CREATE TABLE IF NOT EXISTS `ls_topic_moderation` (
  `topic_id` int(10) unsigned NOT NULL,
  `topic_author` int(10) unsigned NOT NULL,
  `blog_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `topic_author` (`topic_author`),
  KEY `blog_id` (`blog_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_topic_moderation: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_topic_moderation` DISABLE KEYS */;
INSERT INTO `ls_topic_moderation` (`topic_id`, `topic_author`, `blog_id`) VALUES
	(2, 2, 2);
/*!40000 ALTER TABLE `ls_topic_moderation` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_topic_photo
DROP TABLE IF EXISTS `ls_topic_photo`;
CREATE TABLE IF NOT EXISTS `ls_topic_photo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) unsigned DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  `description` text,
  `target_tmp` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `topic_id` (`topic_id`),
  KEY `target_tmp` (`target_tmp`),
  CONSTRAINT `ls_topic_photo_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `ls_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_topic_photo: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_topic_photo` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_topic_photo` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_topic_question_vote
DROP TABLE IF EXISTS `ls_topic_question_vote`;
CREATE TABLE IF NOT EXISTS `ls_topic_question_vote` (
  `topic_id` int(11) unsigned NOT NULL,
  `user_voter_id` int(11) unsigned NOT NULL,
  `answer` tinyint(4) NOT NULL,
  UNIQUE KEY `topic_id_user_id` (`topic_id`,`user_voter_id`),
  KEY `user_voter_id` (`user_voter_id`),
  CONSTRAINT `ls_topic_question_vote_fk` FOREIGN KEY (`topic_id`) REFERENCES `ls_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_topic_question_vote_fk1` FOREIGN KEY (`user_voter_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_topic_question_vote: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_topic_question_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_topic_question_vote` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_topic_read
DROP TABLE IF EXISTS `ls_topic_read`;
CREATE TABLE IF NOT EXISTS `ls_topic_read` (
  `topic_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date_read` datetime NOT NULL,
  `comment_count_last` int(10) unsigned NOT NULL DEFAULT '0',
  `comment_id_last` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `topic_id_user_id` (`topic_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ls_topic_read_fk` FOREIGN KEY (`topic_id`) REFERENCES `ls_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_topic_read_fk1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_topic_read: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_topic_read` DISABLE KEYS */;
INSERT INTO `ls_topic_read` (`topic_id`, `user_id`, `date_read`, `comment_count_last`, `comment_id_last`) VALUES
	(2, 1, '2013-12-10 18:59:28', 0, 0),
	(2, 2, '2013-12-10 19:02:23', 1, 3),
	(3, 1, '2013-12-10 19:02:04', 2, 2),
	(3, 2, '2013-12-10 19:01:16', 2, 2);
/*!40000 ALTER TABLE `ls_topic_read` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_topic_tag
DROP TABLE IF EXISTS `ls_topic_tag`;
CREATE TABLE IF NOT EXISTS `ls_topic_tag` (
  `topic_tag_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `blog_id` int(11) unsigned NOT NULL,
  `topic_tag_text` varchar(50) NOT NULL,
  PRIMARY KEY (`topic_tag_id`),
  KEY `topic_id` (`topic_id`),
  KEY `user_id` (`user_id`),
  KEY `blog_id` (`blog_id`),
  KEY `topic_tag_text` (`topic_tag_text`),
  CONSTRAINT `ls_topic_tag_fk` FOREIGN KEY (`topic_id`) REFERENCES `ls_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_topic_tag_fk1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_topic_tag_fk2` FOREIGN KEY (`blog_id`) REFERENCES `ls_blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_topic_tag: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_topic_tag` DISABLE KEYS */;
INSERT INTO `ls_topic_tag` (`topic_tag_id`, `topic_id`, `user_id`, `blog_id`, `topic_tag_text`) VALUES
	(2, 2, 2, 2, 'First user test'),
	(3, 3, 2, 2, 'dumka');
/*!40000 ALTER TABLE `ls_topic_tag` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_user
DROP TABLE IF EXISTS `ls_user`;
CREATE TABLE IF NOT EXISTS `ls_user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(30) NOT NULL,
  `user_password` varchar(50) NOT NULL,
  `user_mail` varchar(50) NOT NULL,
  `user_skill` float(9,3) unsigned NOT NULL DEFAULT '0.000',
  `user_date_register` datetime NOT NULL,
  `user_date_activate` datetime DEFAULT NULL,
  `user_date_comment_last` datetime DEFAULT NULL,
  `user_ip_register` varchar(20) NOT NULL,
  `user_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `user_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `user_activate` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `user_activate_key` varchar(32) DEFAULT NULL,
  `user_profile_name` varchar(50) DEFAULT NULL,
  `user_profile_sex` enum('man','woman','other') NOT NULL DEFAULT 'other',
  `user_profile_country` varchar(30) DEFAULT NULL,
  `user_profile_region` varchar(30) DEFAULT NULL,
  `user_profile_city` varchar(30) DEFAULT NULL,
  `user_profile_birthday` datetime DEFAULT NULL,
  `user_profile_about` text,
  `user_profile_date` datetime DEFAULT NULL,
  `user_profile_avatar` varchar(250) DEFAULT NULL,
  `user_profile_foto` varchar(250) DEFAULT NULL,
  `user_settings_notice_new_topic` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_new_comment` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_new_talk` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_reply_comment` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_new_friend` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_timezone` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_login` (`user_login`),
  UNIQUE KEY `user_mail` (`user_mail`),
  KEY `user_activate_key` (`user_activate_key`),
  KEY `user_activate` (`user_activate`),
  KEY `user_rating` (`user_rating`),
  KEY `user_profile_sex` (`user_profile_sex`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_user: ~2 rows (approximately)
/*!40000 ALTER TABLE `ls_user` DISABLE KEYS */;
INSERT INTO `ls_user` (`user_id`, `user_login`, `user_password`, `user_mail`, `user_skill`, `user_date_register`, `user_date_activate`, `user_date_comment_last`, `user_ip_register`, `user_rating`, `user_count_vote`, `user_activate`, `user_activate_key`, `user_profile_name`, `user_profile_sex`, `user_profile_country`, `user_profile_region`, `user_profile_city`, `user_profile_birthday`, `user_profile_about`, `user_profile_date`, `user_profile_avatar`, `user_profile_foto`, `user_settings_notice_new_topic`, `user_settings_notice_new_comment`, `user_settings_notice_new_talk`, `user_settings_notice_reply_comment`, `user_settings_notice_new_friend`, `user_settings_timezone`) VALUES
	(1, 'admin', 'a83862769f78fffb512bc9283007ef67', 'max_from_sumy@mail.ru', 0.000, '2012-04-10 00:00:00', NULL, '2013-12-10 19:00:23', '127.0.0.1', 0.000, 0, 1, NULL, NULL, 'other', NULL, NULL, NULL, NULL, NULL, '2013-12-10 16:46:38', '0', NULL, 1, 1, 1, 1, 1, '2'),
	(2, 'max', 'a83862769f78fffb512bc9283007ef67', 'max@mail.ru', 0.000, '2013-12-09 16:20:57', NULL, '2013-12-10 19:02:23', '127.0.0.1', 0.000, 0, 1, NULL, NULL, 'other', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, NULL);
/*!40000 ALTER TABLE `ls_user` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_userfeed_subscribe
DROP TABLE IF EXISTS `ls_userfeed_subscribe`;
CREATE TABLE IF NOT EXISTS `ls_userfeed_subscribe` (
  `user_id` int(11) unsigned NOT NULL,
  `subscribe_type` tinyint(4) NOT NULL,
  `target_id` int(11) NOT NULL,
  KEY `user_id` (`user_id`,`subscribe_type`,`target_id`),
  CONSTRAINT `ls_userfeed_subscribe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_userfeed_subscribe: ~1 rows (approximately)
/*!40000 ALTER TABLE `ls_userfeed_subscribe` DISABLE KEYS */;
INSERT INTO `ls_userfeed_subscribe` (`user_id`, `subscribe_type`, `target_id`) VALUES
	(2, 1, 3);
/*!40000 ALTER TABLE `ls_userfeed_subscribe` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_user_administrator
DROP TABLE IF EXISTS `ls_user_administrator`;
CREATE TABLE IF NOT EXISTS `ls_user_administrator` (
  `user_id` int(11) unsigned NOT NULL,
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_administrator_fk` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_user_administrator: ~1 rows (approximately)
/*!40000 ALTER TABLE `ls_user_administrator` DISABLE KEYS */;
INSERT INTO `ls_user_administrator` (`user_id`) VALUES
	(1);
/*!40000 ALTER TABLE `ls_user_administrator` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_user_changemail
DROP TABLE IF EXISTS `ls_user_changemail`;
CREATE TABLE IF NOT EXISTS `ls_user_changemail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `date_add` datetime NOT NULL,
  `date_used` datetime DEFAULT NULL,
  `date_expired` datetime NOT NULL,
  `mail_from` varchar(50) NOT NULL,
  `mail_to` varchar(50) NOT NULL,
  `code_from` varchar(32) NOT NULL,
  `code_to` varchar(32) NOT NULL,
  `confirm_from` tinyint(1) NOT NULL DEFAULT '0',
  `confirm_to` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `code_from` (`code_from`),
  KEY `code_to` (`code_to`),
  CONSTRAINT `ls_user_changemail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_user_changemail: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_user_changemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_user_changemail` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_user_field
DROP TABLE IF EXISTS `ls_user_field`;
CREATE TABLE IF NOT EXISTS `ls_user_field` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `pattern` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_user_field: ~9 rows (approximately)
/*!40000 ALTER TABLE `ls_user_field` DISABLE KEYS */;
INSERT INTO `ls_user_field` (`id`, `type`, `name`, `title`, `pattern`) VALUES
	(1, 'contact', 'phone', 'Телефон', ''),
	(2, 'contact', 'mail', 'E-mail', '<a href="mailto:{*}" rel="nofollow">{*}</a>'),
	(3, 'contact', 'skype', 'Skype', '<a href="skype:{*}" rel="nofollow">{*}</a>'),
	(4, 'contact', 'icq', 'ICQ', '<a href="http://www.icq.com/people/about_me.php?uin={*}" rel="nofollow">{*}</a>'),
	(5, 'contact', 'www', 'Сайт', '<a href="http://{*}" rel="nofollow">{*}</a>'),
	(6, 'social', 'twitter', 'Twitter', '<a href="http://twitter.com/{*}/" rel="nofollow">{*}</a>'),
	(7, 'social', 'facebook', 'Facebook', '<a href="http://facebook.com/{*}" rel="nofollow">{*}</a>'),
	(8, 'social', 'vkontakte', 'ВКонтакте', '<a href="http://vk.com/{*}" rel="nofollow">{*}</a>'),
	(9, 'social', 'odnoklassniki', 'Одноклассники', '<a href="http://www.odnoklassniki.ru/profile/{*}/" rel="nofollow">{*}</a>');
/*!40000 ALTER TABLE `ls_user_field` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_user_field_value
DROP TABLE IF EXISTS `ls_user_field_value`;
CREATE TABLE IF NOT EXISTS `ls_user_field_value` (
  `user_id` int(11) unsigned NOT NULL,
  `field_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `user_id` (`user_id`,`field_id`),
  KEY `field_id` (`field_id`),
  CONSTRAINT `ls_user_field_value_ibfk_2` FOREIGN KEY (`field_id`) REFERENCES `ls_user_field` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_user_field_value_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_user_field_value: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_user_field_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_user_field_value` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_user_note
DROP TABLE IF EXISTS `ls_user_note`;
CREATE TABLE IF NOT EXISTS `ls_user_note` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_user_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `text` text NOT NULL,
  `date_add` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `target_user_id` (`target_user_id`),
  CONSTRAINT `ls_user_note_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_user_note_ibfk_1` FOREIGN KEY (`target_user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_user_note: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_user_note` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_user_note` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_vote
DROP TABLE IF EXISTS `ls_vote`;
CREATE TABLE IF NOT EXISTS `ls_vote` (
  `target_id` int(11) unsigned NOT NULL DEFAULT '0',
  `target_type` enum('topic','blog','user','comment') NOT NULL DEFAULT 'topic',
  `user_voter_id` int(11) unsigned NOT NULL,
  `vote_direction` tinyint(2) DEFAULT '0',
  `vote_value` float(9,3) NOT NULL DEFAULT '0.000',
  `vote_date` datetime NOT NULL,
  `vote_ip` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`target_id`,`target_type`,`user_voter_id`),
  KEY `user_voter_id` (`user_voter_id`),
  KEY `vote_ip` (`vote_ip`),
  CONSTRAINT `ls_topic_vote_fk1` FOREIGN KEY (`user_voter_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_vote: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_vote` ENABLE KEYS */;


-- Dumping structure for table livestreet.ls_wall
DROP TABLE IF EXISTS `ls_wall`;
CREATE TABLE IF NOT EXISTS `ls_wall` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `wall_user_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `count_reply` int(11) NOT NULL DEFAULT '0',
  `last_reply` varchar(100) NOT NULL,
  `date_add` datetime NOT NULL,
  `ip` varchar(20) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `wall_user_id` (`wall_user_id`),
  KEY `ip` (`ip`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ls_wall_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_wall_ibfk_1` FOREIGN KEY (`wall_user_id`) REFERENCES `ls_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table livestreet.ls_wall: ~0 rows (approximately)
/*!40000 ALTER TABLE `ls_wall` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_wall` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;