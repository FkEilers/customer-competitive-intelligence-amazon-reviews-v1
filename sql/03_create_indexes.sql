-- ============================================================
-- 03_create_indexes.sql
-- CRISP-DM phase: Data Preparation (Silver layer)
--
-- Adds indexes on the columns every downstream query filters or
-- groups by (brand, parent_asin), to keep 05_competitive_analysis
-- queries fast as the dataset scales to the full 2,302 reviews.
--
-- Copied verbatim from MySQL Workbench query history (2026-07-10,
-- 23:48:09–23:48:13) — the successful, corrected version.
--
-- LESSON LEARNED (kept here for documentation, not to be run):
-- The first attempt failed with:
--   CREATE INDEX idx_brand ON reviews_enriched(brand);
--   -- Error Code: 1170. BLOB/TEXT column 'brand' used in key
--   -- specification without a key length
-- Cause: pandas.to_sql() (used earlier to load bronze into MySQL)
-- creates TEXT columns by default for string data, regardless of
-- how short the actual values are. MySQL requires an explicit
-- key-length prefix to index a TEXT/BLOB column. Fixed below by
-- specifying a prefix length long enough for the real data
-- (longest brand name is 17 chars; parent_asin is a fixed 10-char
-- Amazon code) with comfortable margin.
-- ============================================================

USE premium_audio_intelligence;

CREATE INDEX idx_brand ON reviews_enriched(brand(50));
CREATE INDEX idx_parent_asin ON reviews_enriched(parent_asin(20));
