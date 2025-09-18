/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.
===============================================================================
*/


-- Calculate the Total Sales per Year and Running Total of Sales Over Time
SELECT
Order_Year,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY Order_Year) As Running_Total_Sales
FROM
(
SELECT
DATETRUNC(YEAR, order_date) AS Order_Year,
SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
) t



-- Calculate the Total Sales per Month and Running Total of Sales Over Time
SELECT
Order_Month,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY Order_Month) As Running_Total_Sales
FROM
(
SELECT
DATETRUNC(MONTH, order_date) AS Order_Month,
SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
) t



-- Calculate the Total Sales per Month and Running Total of Sales Over Time with Moving Avg. of Price
SELECT
Order_Month,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY Order_Month) As Running_Total_Sales,
AVG(Avg_Price) OVER (ORDER BY Order_Month) As Moving_Avg_Price
FROM
(
SELECT
DATETRUNC(MONTH, order_date) AS Order_Month,
SUM(sales_amount) AS Total_Sales,
AVG(price) AS Avg_Price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
) t
