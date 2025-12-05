CREATE DATABASE IF NOT EXISTS gnb_acapella
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE gnb_acapella;

-- =========================
-- Core entities
-- =========================

-- ARRANGERS
CREATE TABLE arrangers (
  arranger_id      INT AUTO_INCREMENT PRIMARY KEY,
  name             VARCHAR(120) NOT NULL,
  email            VARCHAR(120),
  phone_number     VARCHAR(40),
  affiliation      VARCHAR(120),
  avg_price        DECIMAL(10,2),
  notes            TEXT,
  UNIQUE KEY uq_arrangers_name_email (name, email)
) ENGINE=InnoDB;

-- SONGS (many songs per arranger; each song has 0/1 arranger)
CREATE TABLE songs (
  song_id          INT AUTO_INCREMENT PRIMARY KEY,
  title            VARCHAR(200) NOT NULL,
  arranger_id      INT NULL,
  original_artist  VARCHAR(200),
  is_senior_song   BOOLEAN NOT NULL DEFAULT FALSE,
  notes            TEXT,
  CONSTRAINT fk_songs_arranger
    FOREIGN KEY (arranger_id) REFERENCES arrangers(arranger_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  UNIQUE KEY uq_song_title_arranger (title, arranger_id)
) ENGINE=InnoDB;

-- MEMBERS
CREATE TABLE members (
  member_id        INT AUTO_INCREMENT PRIMARY KEY,
  first_name       VARCHAR(80)  NOT NULL,
  last_name        VARCHAR(80)  NOT NULL,
  email            VARCHAR(120) NOT NULL,
  phone_number     VARCHAR(40),
  vocal_range      VARCHAR(40),          -- e.g., A2–E4 (optional)
  year_joined      SMALLINT,
  year_left        SMALLINT,
  position_title   VARCHAR(120),         -- optional (e.g., President, Music Director)
  notes            TEXT,
  senior_song_id   INT NULL,             -- FK → songs (optional)
  CONSTRAINT fk_members_senior_song
    FOREIGN KEY (senior_song_id) REFERENCES songs(song_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  UNIQUE KEY uq_members_email (email)
) ENGINE=InnoDB;

-- =========================
-- ALUMNI (archived members)
-- =========================
CREATE TABLE alumni (
  member_id        INT PRIMARY KEY,      -- keep same ID as when active
  first_name       VARCHAR(80)  NOT NULL,
  last_name        VARCHAR(80)  NOT NULL,
  email            VARCHAR(120) NOT NULL,
  phone_number     VARCHAR(40),
  vocal_range      VARCHAR(40),
  year_joined      SMALLINT,
  year_left        SMALLINT NOT NULL,    -- alumni should have a leave/graduation year
  position_title   VARCHAR(120),
  notes            TEXT,
  senior_song_id   INT NULL,
  archived_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_alumni_senior_song
    FOREIGN KEY (senior_song_id) REFERENCES songs(song_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  UNIQUE KEY uq_alumni_email (email)
) ENGINE=InnoDB;

-- EVENTS
CREATE TABLE events (
  event_id         INT AUTO_INCREMENT PRIMARY KEY,
  event_name       VARCHAR(200) NOT NULL,
  event_date       DATE,
  location         VARCHAR(200),
  contact_name     VARCHAR(120),
  contact_email    VARCHAR(120),
  contact_phone    VARCHAR(40)
) ENGINE=InnoDB;

-- =========================
-- Multivalued attribute(s)
-- =========================

-- MEMBER ↔ VOICE PARTS (multivalued attribute VoicePart)
-- Using ENUM to match your group’s voicings.
CREATE TABLE member_voice_parts (
  member_id   INT NOT NULL,
  voice_part  ENUM('Soprano','Mezzo-Soprano','Alto','Tenor','Baritone','Bass') NOT NULL,
  PRIMARY KEY (member_id, voice_part),
  CONSTRAINT fk_mvp_member
    FOREIGN KEY (member_id) REFERENCES members(member_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- Ternary relationship: Perform
-- (member performs song at event)
-- =========================
CREATE TABLE performances (
  performance_id INT AUTO_INCREMENT PRIMARY KEY,
  member_id      INT NOT NULL,
  song_id        INT NOT NULL,
  event_id       INT NOT NULL,
  role           VARCHAR(80) NULL,   -- optional: Soloist, Beatbox, etc.
  -- prevent duplicate rows for the same member-song-event triple
  UNIQUE KEY uq_member_song_event (member_id, song_id, event_id),

  CONSTRAINT fk_perf_member
    FOREIGN KEY (member_id) REFERENCES members(member_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_perf_song
    FOREIGN KEY (song_id) REFERENCES songs(song_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_perf_event
    FOREIGN KEY (event_id) REFERENCES events(event_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- TRIGGERS to move graduates
-- =========================
USE gnb_acapella;

DROP TRIGGER IF EXISTS trg_members_to_alumni_before_delete;
DROP TRIGGER IF EXISTS trg_members_archive_on_year_left;

DELIMITER $$

CREATE TRIGGER trg_members_to_alumni_before_delete
BEFORE DELETE ON members
FOR EACH ROW
BEGIN
  IF NOT EXISTS (SELECT 1 FROM alumni WHERE member_id = OLD.member_id) THEN
    INSERT INTO alumni (
      member_id, first_name, last_name, email, phone_number,
      vocal_range, year_joined, year_left, position_title, notes, senior_song_id
    )
    VALUES (
      OLD.member_id, OLD.first_name, OLD.last_name, OLD.email, OLD.phone_number,
      OLD.vocal_range, OLD.year_joined,
      COALESCE(OLD.year_left, YEAR(CURDATE())),
      OLD.position_title, OLD.notes, OLD.senior_song_id
    );
  END IF;
END$$


CREATE TRIGGER trg_members_archive_on_year_left
AFTER UPDATE ON members
FOR EACH ROW
BEGIN
  IF NEW.year_left IS NOT NULL AND OLD.year_left IS NULL THEN
    IF NOT EXISTS (SELECT 1 FROM alumni WHERE member_id = NEW.member_id) THEN
      INSERT INTO alumni (
        member_id, first_name, last_name, email, phone_number,
        vocal_range, year_joined, year_left, position_title, notes, senior_song_id
      )
      VALUES (
        NEW.member_id, NEW.first_name, NEW.last_name, NEW.email, NEW.phone_number,
        NEW.vocal_range, NEW.year_joined, NEW.year_left,
        NEW.position_title, NEW.notes, NEW.senior_song_id
      );
    END IF;
  END IF;
END$$
DELIMITER ;

-- common lookups
CREATE INDEX idx_songs_title ON songs(title);
CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_perf_event ON performances(event_id);
CREATE INDEX idx_perf_song  ON performances(song_id);
CREATE INDEX idx_perf_member ON performances(member_id);
SELECT * FROM MEMBERS;
SELECT * FROM member_voice_parts;

SELECT * FROM MEMBERS;
SELECT * FROM ALUMNI;

SHOW TRIGGERS;

ALTER TABLE members
ADD COLUMN expected_grad_year SMALLINT NULL AFTER year_joined;

DELETE FROM MEMBERS WHERE member_id = 24;

DELETE FROM SONGS WHERE song_id = 5;
SELECT * FROM SONGS