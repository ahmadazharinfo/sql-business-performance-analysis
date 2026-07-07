/*
==============================================================================
Advanced Analytics: Customer Report
==============================================================================
Script Purpose:
    Consolidates every customer-level metric produced in the scripts above
    (segmentation, recency, KPIs) into a single reusable gold-layer view,
    so BI tools and stakeholders can query one clean table.

Technique: Reporting

Contents:
    1. Base query: joins fact_sales with dim_customers, drops nulls.
    2. Aggregates customer-level metrics (orders, sales, quantity,
       products, lifespan).
    3. Segments customers into VIP / Regular / New and into age groups.
    4. Calculates KPIs: recency, average order value, average monthly spend.
==============================================================================
*/

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name)     AS customer_name,
        DATEDIFF(YEAR, c.birthdate, GETDATE())      AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),
customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number)                  AS total_orders,
        SUM(sales_amount)                              AS total_sales,
        SUM(quantity)                                  AS total_quantity,
        COUNT(DISTINCT product_key)                    AS total_products,
        MAX(order_date)                                AS last_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
    FROM base_query
    GROUP BY customer_key, customer_number, customer_name, age
)
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
        WHEN age < 20                  THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29     THEN '20-29'
        WHEN age BETWEEN 30 AND 39     THEN '30-39'
        WHEN age BETWEEN 40 AND 49     THEN '40-49'
        ELSE '50 and above'
    END                                                AS age_group,
    CASE
        WHEN lifespan_months >= 12 AND total_sales > 5000  THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END                                                AS customer_segment,
    last_order_date,
    DATEDIFF(MONTH, last_order_date, GETDATE())        AS recency_months,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan_months,
    -- Average Order Value (AOV)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END                                                AS average_order_value,
    -- Average Monthly Spend
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE total_sales / lifespan_months
    END                                                AS average_monthly_spend
FROM customer_aggregation;
GO
