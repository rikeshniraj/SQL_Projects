/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
===============================================================================
*/



   /* Which Categories contribute the most to overall Sales */

   WITH category_sales AS (
   
   SELECT 
   p.category,
   SUM(f.sales_amount) AS Total_Sales
   from gold.fact_sales f
   LEFT JOIN gold.dim_products p
   on p.product_key = f.product_key
   GROUP BY category)

   SELECT
   Category,
   Total_Sales,
   SUM(Total_Sales) OVER () As Overall_Sales,
   CONCAT(ROUND((CAST (Total_Sales AS FLOAT) / SUM(Total_Sales) OVER () ) * 100, 2), '%') AS Contribution_Percentage_Total
   FROM 
   category_sales
   ORDER BY Total_Sales DESC




  