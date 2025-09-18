/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
===============================================================================
*/


select distinct country from gold.dim_customers
select distinct category, subcategory, product_name from gold.dim_products
order by 1,2,3
