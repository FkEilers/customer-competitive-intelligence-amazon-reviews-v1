-- ============================================================
-- 04_verification_queries.sql
-- CRISP-DM phase: Data Preparation (verification) +
--                 Evaluation (methodological validation)
--
-- Queries used to validate the Silver layer and to investigate
-- two real findings documented in the project handoff:
--   - Why ~53% of Sennheiser reviews have no price (handoff,
--     section 7 / lessons learned)
--   - Whether the collection method introduced temporal bias
--     (handoff, section 8bis, Pregunta 3)
--
-- Copied verbatim from MySQL Workbench query history
-- (2026-07-10 23:49:49 through 2026-07-11 00:39:38).
-- ============================================================

USE premium_audio_intelligence;

-- 1) Summary by brand: volume, average rating, average price,
--    and how many reviews are missing a price
SELECT
    brand,
    COUNT(*) AS n_reviews,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    SUM(CASE WHEN price_usd IS NULL THEN 1 ELSE 0 END) AS missing_price
FROM reviews_enriched
GROUP BY brand
ORDER BY n_reviews DESC;

-- 2) Investigation: which specific Sennheiser products are missing
--    price? (Finding: spread across ~14+ Momentum generations/variants,
--    many marked "Discontinued by Manufacturer" — not a data bug.)
SELECT product_title, price_raw, COUNT(*) AS n_reviews
FROM reviews_enriched
WHERE brand = 'Sennheiser' AND price_usd IS NULL
GROUP BY product_title, price_raw
ORDER BY n_reviews DESC;

-- 3) Temporal bias check: date range covered per brand
--    (Finding: 5.4 to 10.3 years per brand, reaching the dataset's
--    own Sept. 2023 cutoff — no evidence of a narrow/biased window.)
SELECT
    brand,
    COUNT(*) AS n_reviews,
    FROM_UNIXTIME(MIN(timestamp)/1000) AS earliest_review,
    FROM_UNIXTIME(MAX(timestamp)/1000) AS latest_review,
    DATEDIFF(FROM_UNIXTIME(MAX(timestamp)/1000), FROM_UNIXTIME(MIN(timestamp)/1000)) AS days_span
FROM reviews_enriched
GROUP BY brand
ORDER BY brand;

-- 4) Temporal bias check: year-by-year distribution per brand
--    (Finding: peaks/valleys consistent with real product-generation
--    launch cycles, not an artifact of file ordering.)
SELECT
    brand,
    YEAR(FROM_UNIXTIME(timestamp/1000)) AS review_year,
    COUNT(*) AS n_reviews
FROM reviews_enriched
GROUP BY brand, review_year
ORDER BY brand, review_year;
