/*
==============================================================================
Init: Data Analytics Layer
==============================================================================
Script Purpose:
    Connects the analytics scripts to the existing DataWarehouse database
    built in the "sql-medallion-architecture-data-warehouse-full-project".
    This project consumes the gold layer views (gold.dim_customers,
    gold.dim_products, gold.fact_sales) as its single source of truth.

Prerequisite:
    Run the previous project's scripts/init_database.sql, ddl_bronze.sql,
    proc_load_bronze.sql, ddl_silver.sql, proc_load_silver.sql, and
    ddl_gold.sql first, so the gold views already exist.

Usage:
    Run this once per session before executing the numbered analysis
    scripts (01 -> 13).
==============================================================================
*/

USE DataWarehouse;
GO

-- Quick sanity check: confirm the gold layer is reachable before analyzing it
SELECT 'gold.dim_customers' AS object_name, COUNT(*) AS row_count FROM gold.dim_customers
UNION ALL
SELECT 'gold.dim_products', COUNT(*) FROM gold.dim_products
UNION ALL
SELECT 'gold.fact_sales', COUNT(*) FROM gold.fact_sales;
GO
