/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
       - To understand the range of historical data.
===============================================================================
*/



-- Explore Date in the Database
select 
MIN(order_date) AS First_Order_date,
MAX(order_date) AS Last_Order_date,
DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS Order_Range_years,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Order_Range_Months
from gold.fact_sales



-- Youngest and Oldest Customer
select 
MIN(birthdate) AS Oldest_Customer,
DATEDIFF(YEAR, MIN(birthdate), GETDATE()) As Oldest_Age,
MAX(birthdate) AS Youngest_Customer,
DATEDIFF(YEAR, MAX(birthdate), GETDATE()) As Youngest_Age
from gold.dim_customers
