-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: gnb_acapella
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alumni`
--

DROP TABLE IF EXISTS `alumni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumni` (
  `member_id` int NOT NULL,
  `first_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vocal_range` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `year_joined` smallint DEFAULT NULL,
  `year_left` smallint NOT NULL,
  `position_title` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `senior_song_id` int DEFAULT NULL,
  `archived_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `uq_alumni_email` (`email`),
  KEY `fk_alumni_senior_song` (`senior_song_id`),
  CONSTRAINT `fk_alumni_senior_song` FOREIGN KEY (`senior_song_id`) REFERENCES `songs` (`song_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumni`
--

LOCK TABLES `alumni` WRITE;
/*!40000 ALTER TABLE `alumni` DISABLE KEYS */;
INSERT INTO `alumni` VALUES (32,'Connor','Farrel','connor.farrell@marquette.edu',NULL,NULL,2021,2025,NULL,NULL,NULL,'2025-11-25 03:28:31'),(35,'Charlie','O\'Neill','charles.oneill@marquette.edu',NULL,NULL,NULL,2025,NULL,NULL,NULL,'2025-11-25 05:06:05');
/*!40000 ALTER TABLE `alumni` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arrangers`
--

DROP TABLE IF EXISTS `arrangers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arrangers` (
  `arranger_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `affiliation` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avg_price` decimal(10,2) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`arranger_id`),
  UNIQUE KEY `uq_arrangers_name_email` (`name`,`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arrangers`
--

LOCK TABLES `arrangers` WRITE;
/*!40000 ALTER TABLE `arrangers` DISABLE KEYS */;
INSERT INTO `arrangers` VALUES (1,'Phil','Phil@email.com','1234252342','GnB Alumni',NULL,NULL);
/*!40000 ALTER TABLE `arrangers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `event_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_date` date DEFAULT NULL,
  `location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'Christmas Lighting Event','2025-11-20','Pere Marquette Park ','N/A','N/A','N/A'),(2,'ICCAs','2026-02-14','Madison',NULL,NULL,NULL);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_positions`
--

DROP TABLE IF EXISTS `member_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_positions` (
  `member_id` int NOT NULL,
  `year` smallint NOT NULL,
  `position_title` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`member_id`,`year`,`position_title`),
  CONSTRAINT `fk_pos_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_positions`
--

LOCK TABLES `member_positions` WRITE;
/*!40000 ALTER TABLE `member_positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_voice_parts`
--

DROP TABLE IF EXISTS `member_voice_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_voice_parts` (
  `member_id` int NOT NULL,
  `voice_part` enum('Soprano','Mezzo-Soprano','Alto','Tenor','Baritone','Bass') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`member_id`,`voice_part`),
  CONSTRAINT `fk_mvp_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_voice_parts`
--

LOCK TABLES `member_voice_parts` WRITE;
/*!40000 ALTER TABLE `member_voice_parts` DISABLE KEYS */;
INSERT INTO `member_voice_parts` VALUES (26,'Baritone'),(26,'Bass'),(31,'Tenor'),(31,'Baritone');
/*!40000 ALTER TABLE `member_voice_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vocal_range` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `year_joined` smallint DEFAULT NULL,
  `expected_grad_year` smallint DEFAULT NULL,
  `year_left` smallint DEFAULT NULL,
  `position_title` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `senior_song_id` int DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `uq_members_email` (`email`),
  KEY `fk_members_senior_song` (`senior_song_id`),
  CONSTRAINT `fk_members_senior_song` FOREIGN KEY (`senior_song_id`) REFERENCES `songs` (`song_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (26,'Timothy','Gnorski','timothy.gnorski@marquette.edu',NULL,NULL,2023,2027,NULL,NULL,NULL,NULL),(27,'Mckinnley','Marks','mckinnley.marks@marquette.edu',NULL,NULL,2022,2026,NULL,NULL,NULL,NULL),(28,'Kane','Undag','kanemikelharvey.undag@marquette.edu',NULL,NULL,2023,2027,NULL,NULL,NULL,NULL),(29,'Max','Creger-Roberts','maxwell.creager-roberts@marquette.edu',NULL,NULL,2023,2026,NULL,NULL,NULL,NULL),(30,'Bennett','Chapman','bennett.chapman@marquette.edu','8163928681','F2-F5 Break:D4',2024,2028,NULL,'None',NULL,NULL),(31,'London','Downey','london.downey@marquette.edu',NULL,NULL,2025,2029,NULL,NULL,NULL,NULL),(34,'Moira','Sagon','moira.sagon@marquette.edu','7089901261','Eb3-B6 Break:B5',2024,2028,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performances`
--

DROP TABLE IF EXISTS `performances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performances` (
  `performance_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `song_id` int NOT NULL,
  `event_id` int NOT NULL,
  `role` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`performance_id`),
  UNIQUE KEY `uq_member_song_event` (`member_id`,`song_id`,`event_id`),
  KEY `fk_perf_song` (`song_id`),
  KEY `fk_perf_event` (`event_id`),
  CONSTRAINT `fk_perf_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_perf_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_perf_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`song_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performances`
--

LOCK TABLES `performances` WRITE;
/*!40000 ALTER TABLE `performances` DISABLE KEYS */;
INSERT INTO `performances` VALUES (2,27,9,2,'Soloist'),(3,30,8,2,'Soloist'),(4,34,7,2,'Soloist'),(5,26,2,1,'Solist'),(6,31,7,1,'Soloist');
/*!40000 ALTER TABLE `performances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `songs`
--

DROP TABLE IF EXISTS `songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `songs` (
  `song_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `arranger_id` int DEFAULT NULL,
  `original_artist` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_senior_song` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`song_id`),
  UNIQUE KEY `uq_song_title_arranger` (`title`,`arranger_id`),
  KEY `fk_songs_arranger` (`arranger_id`),
  CONSTRAINT `fk_songs_arranger` FOREIGN KEY (`arranger_id`) REFERENCES `arrangers` (`arranger_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songs`
--

LOCK TABLES `songs` WRITE;
/*!40000 ALTER TABLE `songs` DISABLE KEYS */;
INSERT INTO `songs` VALUES (1,'StillFeel',NULL,'Half Alive',0,NULL),(2,'Renegade',NULL,'Styx',0,NULL),(3,'Christmas (Baby Please Come Home) ',NULL,'Michale Buble ',0,NULL),(4,'',NULL,'',0,NULL),(7,'Training Season',1,'Dua Lipa',0,NULL),(8,'Biting My Tongue',1,'Duncan Lawrence',0,NULL),(9,'Holding Out For A Hero',1,'Bonnie Tyler',0,NULL),(10,'Noel',1,NULL,0,NULL);
/*!40000 ALTER TABLE `songs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-04 19:51:38
