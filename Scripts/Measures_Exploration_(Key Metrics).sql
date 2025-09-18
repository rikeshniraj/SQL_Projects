/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends.
===============================================================================
*/


-- Find the Total Sales
select 
SUM(sales_amount) As Total_Sales 
from gold.fact_sales



-- Find How many Items are Sold
select 
SUM(quantity) As Total_Items_Sold 
from gold.fact_sales



-- Find the Average Selling Price
select 
AVG(price) As Average_Selling_Price
from gold.fact_sales


-- Find the Total Number of Orders
select 
COUNT(order_number) AS Total_Orders,
COUNT(DISTINCT order_number) AS Total_Distict_Orders
from gold.fact_sales



-- Find the Total Number of Products
select 
COUNT(product_key) As Total_Products
from gold.dim_products



-- Find the Total Number of Customers
select 
COUNT(customer_id) As Total_Customer
from gold.dim_customers



-- Find the Total Number of Customers that has Placed the Order
select 
COUNT(DISTINCT customer_key) As Total_Ordered_Customer
from gold.fact_sales




-- Generate a Report that Shows all Key Metrics of the Business
select 'Total Sales' AS Name, SUM(sales_amount) As Value from gold.fact_sales
UNION ALL
select 'Total Quantity', SUM(quantity) from gold.fact_sales
UNION ALL
select 'Average Price', AVG(price) from gold.fact_sales
UNION ALL
select 'Total Order', COUNT(order_number) from gold.fact_sales
UNION ALL
SELECT 'Total Distinct Order', COUNT(DISTINCT order_number) from gold.fact_sales
UNION ALL
select 'Total Number Of Product' AS Measure_name,COUNT(product_key) from gold.dim_products
UNION ALL
select 'Total Number Of Customers', COUNT(customer_id) from gold.dim_customers
UNION ALL
select 'Total Number Of Customers has Placed Order', COUNT(DISTINCT customer_key) from gold.fact_sales
