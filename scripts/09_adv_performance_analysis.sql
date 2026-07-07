/*
==============================================================================
Advanced Analytics: Performance Analysis (Year-over-Year)
==============================================================================
Script Purpose:
    Compares the yearly performance of each product against its own
    historical average and against the prior year, to flag whether a
    product is over/under-performing and trending up or down.

Technique: Performance Analysis
==============================================================================
*/

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date)  AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_revenue
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
    order_year,
    product_name,
    current_revenue,
    AVG(current_revenue) OVER (PARTITION BY product_name)                 AS average_revenue,
    current_revenue - AVG(current_revenue) OVER (PARTITION BY product_name) AS diff_from_average,
    CASE
        WHEN current_revenue - AVG(current_revenue) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN current_revenue - AVG(current_revenue) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END                                                                     AS average_flag,
    LAG(current_revenue) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_revenue,
    current_revenue - LAG(current_revenue) OVER (PARTITION BY product_name ORDER BY order_year) AS yoy_diff,
    CASE
        WHEN current_revenue - LAG(current_revenue) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_revenue - LAG(current_revenue) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END                                                                     AS yoy_trend
FROM yearly_product_sales
ORDER BY product_name, order_year;
