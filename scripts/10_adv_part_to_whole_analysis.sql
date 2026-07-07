/*
==============================================================================
Advanced Analytics: Part-to-Whole (Proportional) Analysis
==============================================================================
Script Purpose:
    Measures what percentage each category/country contributes to the
    overall business, to identify which parts matter most to the whole.

Technique: Part-to-Whole Analysis
==============================================================================
*/

-- Which product category contributes the most to overall revenue?
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_revenue
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_revenue,
    SUM(total_revenue) OVER ()                                              AS overall_revenue,
    CONCAT(ROUND(CAST(total_revenue AS FLOAT) / SUM(total_revenue) OVER () * 100, 2), '%') AS pct_of_total
FROM category_sales
ORDER BY total_revenue DESC;

-- Which country contributes the most to overall order quantity?
WITH country_quantity AS (
    SELECT
        c.country,
        SUM(f.quantity) AS total_quantity
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.country
)
SELECT
    country,
    total_quantity,
    SUM(total_quantity) OVER ()                                                 AS overall_quantity,
    CONCAT(ROUND(CAST(total_quantity AS FLOAT) / SUM(total_quantity) OVER () * 100, 2), '%') AS pct_of_total
FROM country_quantity
ORDER BY total_quantity DESC;
