/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.
===============================================================================
*/

--Analyze Yearly Sales Performance Over Time
SELECT 
YEAR(order_date) AS Order_Year,
SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)


--Analyze Yearly Sales Performance Over Time With Total Customers
SELECT 
YEAR(order_date) AS Order_Year,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Cutomer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)


--Analyze Yearly Sales Performance Over Time With Total Customers and Total Quantities
SELECT 
YEAR(order_date) AS Order_Year,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Cutomer,
SUM(quantity) AS Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)



--Analyze Every Year, Monthly Sales Performance Over Time
SELECT 
YEAR(order_date) AS Order_Year,
MONTH(order_date) AS Order_Month,
SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)



--Analyze Every Year, Monthly Sales Performance Over Time With Total Customers and Total Quantities
SELECT 
DATETRUNC(MONTH, order_date) AS Order_Date,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Cutomer,
SUM(quantity) AS Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)



