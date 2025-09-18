/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for meaningful insights.
    - For customer segmentation, product categorization.
===============================================================================
*/


    -- Data Segmentation

   /* Segment Products into Cost Ranges and Count how many Products fall into each Segment */

   WITH Product_Segment AS (

   SELECT
   product_key,
   product_name,
   cost,
   CASE WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END Cost_Range
   FROM gold.dim_products)

   SELECT
   Cost_Range,
   COUNT (product_key) AS Total_Products
   FROM Product_Segment
   GROUP BY Cost_Range
   ORDER BY Total_Products DESC



