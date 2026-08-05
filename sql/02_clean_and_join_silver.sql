-- ============================================================
-- 02_clean_and_join_silver.sql
-- CRISP-DM phase: Data Preparation (Silver layer)
--
-- Cleans and joins the bronze-layer tables (products_bronze,
-- reviews_bronze) into a single Silver table: reviews_enriched.
--
-- Cleaning rules applied (all decided jointly, documented in
-- handoff doc section 2 with full rationale):
--   - Drop reviews with null/empty text
--   - Drop reviews with rating outside 1-5
--   - Deduplicate strictly: same parent_asin + text + timestamp
--     (via ROW_NUMBER() OVER PARTITION BY, keep rn = 1)
--   - Inner join to products — drops any orphan review with no
--     matching product (none were found: 0 orphans confirmed)
--   - Parse price from "$299.99" text to a real DECIMAL number
--
-- Copied verbatim from MySQL Workbench query history
-- (2026-07-10, 23:36:53–23:37:11).
--
-- Result when originally run: 2,302 rows (2,312 bronze reviews
-- minus 10 strict duplicates).
-- ============================================================

USE premium_audio_intelligence;

-- Increase sort buffer for this session — ROW_NUMBER() OVER
-- (PARTITION BY ... ORDER BY long review text) needs more sort
-- memory than MySQL's default when the ORDER BY column is long
-- text, not just when there are many rows. Session-only, not a
-- permanent server setting. (See handoff doc, lessons learned.)
SET SESSION sort_buffer_size = 4194304;

DROP TABLE IF EXISTS reviews_enriched;

CREATE TABLE reviews_enriched AS
SELECT
    parent_asin, brand, review_rating, review_title, review_text,
    timestamp, verified_purchase, detected_language,
    product_title, price_raw, price_usd,
    product_average_rating, product_rating_number
FROM (
    SELECT
        r.parent_asin,
        r.brand,
        r.rating AS review_rating,
        r.title AS review_title,
        TRIM(r.text) AS review_text,
        r.timestamp,
        r.verified_purchase,
        r.detected_language,
        p.title AS product_title,
        p.price AS price_raw,
        CAST(REPLACE(REPLACE(p.price, '$', ''), ',', '') AS DECIMAL(10,2)) AS price_usd,
        p.average_rating AS product_average_rating,
        p.rating_number AS product_rating_number,
        ROW_NUMBER() OVER (
            PARTITION BY r.parent_asin, TRIM(r.text), r.timestamp
            ORDER BY r.parent_asin
        ) AS rn
    FROM reviews_bronze r
    INNER JOIN products_bronze p ON r.parent_asin = p.parent_asin
    WHERE
        r.text IS NOT NULL
        AND TRIM(r.text) != ''
        AND r.rating BETWEEN 1 AND 5
) AS deduped
WHERE rn = 1;

-- Quick sanity check after creating the table
SELECT COUNT(*) FROM products_bronze;
SELECT COUNT(*) FROM reviews_bronze;
SELECT COUNT(*) FROM reviews_enriched;
