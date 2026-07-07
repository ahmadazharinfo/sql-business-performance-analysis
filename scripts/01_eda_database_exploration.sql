/*
==============================================================================
EDA: Database Exploration
==============================================================================
Script Purpose:
    First step of Exploratory Data Analysis (EDA). Explores the structure of
    the gold layer: which objects exist, and what columns each one exposes.
    This orients us before running any business analysis.

Technique: Database Exploration
==============================================================================
*/

-- Explore all objects in the database
SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Explore all columns of the gold layer views
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
