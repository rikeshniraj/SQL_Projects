/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For identifying high-performing entities.
    - To track yearly trends and growth.
===============================================================================
*/



/* Analyze the Yearly Performance of Products by comparing each Product's Sales to both its 
   Average Sales Peroformance and the Previous Year's Sales. */
  
  WITH Yearly_Product_Sales AS (

   SELECT
   YEAR(f.order_date) As Order_Year,
   p.product_name As Product_Name,
   SUM(f.sales_amount) As Total_Sales
   from gold.fact_sales f
   LEFT JOIN gold.dim_products p
   ON p.product_key = f.product_key
   WHERE order_date IS NOT NULL
   GROUP BY YEAR(f.order_date), Product_Name
   )

   SELECT 
   Order_Year,
   Product_Name,
   Total_Sales,
   AVG(Total_Sales) OVER (PARTITION BY Product_Name) AS Average_Sales,
   Total_Sales - AVG(Total_Sales) OVER (PARTITION BY Product_Name) As Avg_Sales_Diff,
   CASE WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY Product_Name) > 0 THEN 'Above Avg.'
        WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY Product_Name) < 0 THEN 'Below Avg.'
        ELSE 'At Avg.'
    END As Avg_Diff_Details,
    Total_Sales,
    LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) As Prev_Year_Sales,
    Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) As Sales_Diff_With_Prev_Year,
    CASE WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) > 0 THEN 'Above Prev Year'
         WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) < 0 THEN 'Below Prev Year'
         ELSE 'No Change'
    END As Sales_Diff_Details
  FROM
   Yearly_Product_Sales
   ORDER BY Product_Name, Order_Year



   /* Analyze the Monthly Performance of Products by comparing each Product's Sales to both its 
   Average Sales Peroformance and the Previous Month's Sales. */
  
  WITH Monthly_Product_Sales AS (

   SELECT
   DATETRUNC(MONTH, f.order_date) As Order_Month,
   p.product_name As Product_Name,
   SUM(f.sales_amount) As Total_Sales
   from gold.fact_sales f
   LEFT JOIN gold.dim_products p
   ON p.product_key = f.product_key
   WHERE order_date IS NOT NULL
   GROUP BY DATETRUNC(MONTH, f.order_date), Product_Name
   )

   SELECT 
   Order_Month,
   Product_Name,
   Total_Sales,
   AVG(Total_Sales) OVER (PARTITION BY Product_Name) AS Average_Sales,
   Total_Sales - AVG(Total_Sales) OVER (PARTITION BY Product_Name) As Avg_Sales_Diff,
   CASE WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY Product_Name) > 0 THEN 'Above Avg.'
        WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY Product_Name) < 0 THEN 'Below Avg.'
        ELSE 'At Avg.'
    END As Avg_Diff_Details,
    Total_Sales,
    LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Month) As Prev_Month_Sales,
    Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Month) As Sales_Diff_With_Prev_Month,
    CASE WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Month) > 0 THEN 'Above Prev Month'
         WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Month) < 0 THEN 'Below Prev Month'
         ELSE 'No Change'
    END As Sales_Diff_Details
  FROM
   Monthly_Product_Sales
   ORDER BY Product_Name, Order_Month



   