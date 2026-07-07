/*
==============================================================================
Advanced Analytics: Data Segmentation
==============================================================================
Script Purpose:
    Groups products and customers into meaningful buckets based on behavior
    (cost tiers, spending tiers) instead of treating them as one flat pool.

Technique: Data Segmentation
==============================================================================
*/

-- Segment products into cost ranges, and count how many products fall in each
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100                    THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500       THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000       THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

-- Segment customers into VIP / Regular / New, based on lifespan and total spending:
--   VIP:     lifespan >= 12 months AND total spending > 5,000
--   Regular: lifespan >= 12 months AND total spending <= 5,000
--   New:     lifespan < 12 months
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount)                                        AS total_spending,
        MIN(f.order_date)                                          AS first_order_date,
        MAX(f.order_date)                                          AS last_order_date,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date))       AS lifespan_months
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
