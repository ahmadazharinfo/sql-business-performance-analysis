/*
==============================================================================
EDA: Measures Exploration (Big Numbers)
==============================================================================
Script Purpose:
    Calculates the key business metrics ("big numbers") that summarize the
    whole business at a glance: total revenue, orders, quantity sold,
    average price, and headcounts of customers/products.

Technique: Measures Exploration
==============================================================================
*/

-- Total sales revenue
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Total quantity of items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Average selling price
SELECT AVG(price) AS average_price FROM gold.fact_sales;

-- Total number of orders (unique order numbers)
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Total number of products
SELECT COUNT(*) AS total_products FROM gold.dim_products;

-- Total number of customers
SELECT COUNT(*) AS total_customers FROM gold.dim_customers;

-- Total number of customers who have placed at least one order
SELECT COUNT(DISTINCT customer_key) AS total_ordering_customers FROM gold.fact_sales;

-- Consolidated "big numbers" report, all metrics in one result set
SELECT 'Total Sales'         AS measure_name, SUM(sales_amount)          AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity',            SUM(quantity)                       FROM gold.fact_sales
UNION ALL
SELECT 'Average Price',             AVG(price)                          FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders',              COUNT(DISTINCT order_number)        FROM gold.fact_sales
UNION ALL
SELECT 'Total Products',            COUNT(*)                            FROM gold.dim_products
UNION ALL
SELECT 'Total Customers',           COUNT(*)                            FROM gold.dim_customers
UNION ALL
SELECT 'Total Ordering Customers',  COUNT(DISTINCT customer_key)        FROM gold.fact_sales;
