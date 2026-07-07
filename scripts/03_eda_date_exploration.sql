/*
==============================================================================
EDA: Date Exploration
==============================================================================
Script Purpose:
    Finds the boundaries of the time dimension: the first/last order date,
    the sales history span, and the age range of customers.

Technique: Date Exploration
==============================================================================
*/

-- Range of order dates and how many years/months of sales history exist
SELECT
    MIN(order_date)                                   AS first_order_date,
    MAX(order_date)                                   AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS sales_history_months,
    DATEDIFF(YEAR,  MIN(order_date), MAX(order_date)) AS sales_history_years
FROM gold.fact_sales;

-- Youngest and oldest customer, based on birthdate
SELECT
    MIN(birthdate)                                    AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE())          AS oldest_customer_age,
    MAX(birthdate)                                    AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE())          AS youngest_customer_age
FROM gold.dim_customers;
