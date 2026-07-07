/*
==============================================================================
EDA: Dimensions Exploration
==============================================================================
Script Purpose:
    Identifies the unique values (categories) within each dimension.
    Understanding the "shape" of dim_customers and dim_products before
    building any measures on top of them.

Technique: Dimensions Exploration
==============================================================================
*/

-- All countries customers come from
SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country;

-- All marital statuses and genders
SELECT DISTINCT marital_status, gender
FROM gold.dim_customers
ORDER BY marital_status, gender;

-- All categories, subcategories and product lines ("product hierarchy")
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;

-- Distinct maintenance and product line values
SELECT DISTINCT product_line, maintenance
FROM gold.dim_products
ORDER BY product_line, maintenance;
