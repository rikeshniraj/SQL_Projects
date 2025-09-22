--  Checking & Transformation on Sales Table

-- Check for Unwanted Spaces

SELECT
sls_ord_num
FROM [bronze.crm_sales_details]
WHERE sls_ord_num != TRIM(sls_ord_num) -- Check for Every Required column

SELECT
sls_prd_key
FROM [bronze.crm_sales_details]
WHERE sls_prd_key != TRIM(sls_prd_key) -- Check for Every Required column



-- Check for Nulls, Zeros and Negative Numbers also Sales = Price * Quantity

SELECT
sls_cust_id
FROM [bronze.crm_sales_details]
WHERE sls_cust_id < 0 OR sls_cust_id IS NULL

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM [bronze.crm_sales_details]
WHERE sls_sales != sls_quantity * sls_price
     OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL   
     OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price


-- Before Transform the data need too discuss with the Business Expert/Client/Admin
-- If they agree we transform Data based on the discussion.
/* Rules are :- If Sales Negative, Zero or Null then derive it using Qunatity * Price
                If Price is Null or Neative the derive it using Sales / Quantity 
                If price is Neative then convert to Positive Value   */
-- Transformation Steps              

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_price AS old_sls_price,
sls_quantity,

CASE WHEN sls_price <= 0 OR sls_price IS NULL
     THEN sls_sales / NULLIF(sls_quantity, 0)
     ELSE sls_price
END AS sls_price,

CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
     THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales

FROM [bronze.crm_sales_details]




-- Check for Order Date is Not Greater than Ship date and Due date

SELECT
*
FROM [bronze.crm_sales_details]
WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt



-- Final Transformation Steps

SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,

CASE WHEN sls_price <= 0 OR sls_price IS NULL
     THEN sls_sales / NULLIF(sls_quantity, 0)
     ELSE sls_price
END AS sls_price,

sls_quantity,

CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
     THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales

FROM [bronze.crm_sales_details]





-- Create & Insert Transformed data to New Table Called crm_sales_info

CREATE TABLE crm_sales_info (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_price       INT,
    sls_quantity    INT,
    sls_sales       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()   
);


INSERT INTO crm_sales_info (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_price,
            sls_quantity,
            sls_sales)

SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,

CASE WHEN sls_price <= 0 OR sls_price IS NULL
     THEN sls_sales / NULLIF(sls_quantity, 0)
     ELSE sls_price
END AS sls_price,

sls_quantity,

CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
     THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales

FROM [bronze.crm_sales_details]
