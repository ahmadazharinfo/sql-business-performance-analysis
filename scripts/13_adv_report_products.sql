/*
==============================================================================
Advanced Analytics: Product Report
==============================================================================
Script Purpose:
    Consolidates every product-level metric into a single reusable
    gold-layer view: revenue, quantity, customer reach, recency, and a
    performance segment for each product.

Technique: Reporting

Contents:
    1. Base query: joins fact_sales with dim_products, drops nulls.
    2. Aggregates product-level metrics (orders, sales, quantity,
       customers, lifespan).
    3. Segments products into High-Performer / Mid-Range / Low-Performer.
    4. Calculates KPIs: recency, average order revenue, average monthly revenue.
==============================================================================
*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS (
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),
product_aggregation AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT order_number)                  AS total_orders,
        SUM(sales_amount)                              AS total_sales,
        SUM(quantity)                                  AS total_quantity,
        COUNT(DISTINCT customer_key)                   AS total_customers,
        MAX(order_date)                                AS last_sale_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months,
        CASE
            WHEN SUM(quantity) = 0 THEN 0
            ELSE SUM(sales_amount) / SUM(quantity)
        END                                             AS average_selling_price
    FROM base_query
    GROUP BY product_key, product_name, category, subcategory, cost
)
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    average_selling_price,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END                                                AS performance_segment,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE())         AS recency_months,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    lifespan_months,
    -- Average Order Revenue (AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END                                                AS average_order_revenue,
    -- Average Monthly Revenue
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE total_sales / lifespan_months
    END                                                AS average_monthly_revenue
FROM product_aggregation;
GO
