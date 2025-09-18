/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.
===============================================================================
*/


-- Which 5 Products Generate the Highest Revenue
SELECT TOP 5
P.category As Category,
p.subcategory As Subcategory,
p.product_name As Product_Name,
SUM(f.sales_amount) As Total_Revenue
from gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY 
p.product_name,
P.category,
p.subcategory
order BY Total_Revenue DESC




-- What are the 5 wrost performing Products in terms of Sales
SELECT TOP 5
P.category As Category,
p.subcategory As Subcategory,
p.product_name As Product_Name,
SUM(f.sales_amount) As Total_Revenue
from gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY 
p.product_name,
P.category,
p.subcategory
order by Total_Revenue




-- Which 5 Subcategory Generate the Highest Revenue
SELECT TOP 5
p.subcategory As Subcategory,
SUM(f.sales_amount) As Total_Revenue
from gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY 
p.subcategory
order by Total_Revenue DESC




-- Which 5 Subcategory Generate the Lowest Revenue
SELECT TOP 5
p.subcategory As Subcategory,
SUM(f.sales_amount) As Total_Revenue
from gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY 
p.subcategory
order by Total_Revenue




-- Rank the Products by Total Sales
SELECT
P.category As Category,
p.subcategory As Subcategory,
p.product_name As Product_name,
SUM(f.sales_amount) As Total_Revenue,
ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS Rank_Products
from gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY 
p.product_name,
P.category,
p.subcategory




-- Rank Top 5 Products by Total Sales
SELECT *
FROM  (
	SELECT
	P.category As Category,
	p.subcategory As Subcategory,
	p.product_name As Product_name,
	SUM(f.sales_amount) As Total_Revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS Rank_Products
	from gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY 
	p.product_name,
	P.category,
	p.subcategory)t
WHERE Rank_Products <= 5





-- Find the Top 10 Customers who have Generated the Highest Revenue with Rank
SELECT *
FROM  (
	SELECT
	c.customer_key As Customer_Id,
	c.first_name As First_Name,
	c.last_name As Last_Name,
	SUM(f.sales_amount) As Total_Revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS Rank_Sales
	from gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
	GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name)t
WHERE Rank_Sales <= 10




-- The 3 Customers with the Fewest Order Placed

SELECT TOP 3
c.customer_key As Customer_Id,
c.first_name As First_Name,
c.last_name As Last_Name,
COUNT(DISTINCT f.order_number) As Total_Order
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY Total_Order
