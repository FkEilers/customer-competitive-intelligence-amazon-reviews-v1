-- ============================================================
-- 01_create_schema.sql
-- CRISP-DM phase: Data Preparation (Silver layer setup)
--
-- Creates the MySQL schema used for cleaning and joining the
-- bronze-layer data (products + reviews) into the Silver layer.
--
-- NOTE: this specific statement was run in an earlier Workbench
-- session and does not appear in the retrieved query history —
-- reconstructed here from project documentation (handoff doc,
-- section 6), not copied verbatim from history like the other
-- scripts in this folder. It is a single trivial statement, low
-- risk of transcription error.
-- ============================================================

CREATE SCHEMA IF NOT EXISTS premium_audio_intelligence
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE premium_audio_intelligence;
