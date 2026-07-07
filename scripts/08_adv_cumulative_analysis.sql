/*
==============================================================================
Advanced Analytics: Cumulative Analysis
==============================================================================
Script Purpose:
    Calculates running totals and moving averages to understand whether the
    business is growing cumulatively over time.

Technique: Cumulative Analysis
==============================================================================
*/

-- Running total of monthly revenue, and a moving average of monthly price
SELECT
    order_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY order_month)               AS running_total_revenue,
    AVG(average_price)   OVER (ORDER BY order_month)               AS moving_average_price
FROM (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount)            AS monthly_revenue,
        AVG(price)                   AS average_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) monthly_sales
ORDER BY order_month;

-- Running total of yearly revenue (resets perspective at year granularity)
SELECT
    order_year,
    yearly_revenue,
    SUM(yearly_revenue) OVER (ORDER BY order_year) AS running_total_revenue
FROM (
    SELECT
        YEAR(order_date)   AS order_year,
        SUM(sales_amount)  AS yearly_revenue
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
) yearly_sales
ORDER BY order_year;
