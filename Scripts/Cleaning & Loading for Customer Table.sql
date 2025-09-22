--  Checking & Transformation on Customer Table

-- Check for Nulls and Duplicates in Primary Key
-- A Primary Key must be Unique and Not Null

SELECT
cst_id,
COUNT(*)
FROM [bronze.crm_cust_info]
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL -- If COUNT show more than 1 for any ID then it is Duplicates or If any NULL it shows.

-- Transformation Steps
SELECT 
*
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_Latest
	FROM [bronze.crm_cust_info])t
    WHERE Flag_Latest =1 AND cst_id = 29466





-- Check for Unwanted Spaces

SELECT
cst_firstname
FROM [bronze.crm_cust_info]
WHERE cst_firstname != TRIM(cst_firstname) -- Check for Every Required column

-- Transformation Steps

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) As cst_firstname,
TRIM(cst_lastname) As cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
FROM [bronze.crm_cust_info]
WHERE cst_lastname IS NOT NULL AND cst_lastname IS NOT NULL
      




-- Data Standardization and Consistency

SELECT
DISTINCT cst_gndr
FROM [bronze.crm_cust_info] 
	

-- Transformation Steps

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) As cst_firstname,
TRIM(cst_lastname) As cst_lastname,
cst_marital_status,
CASE WHEN cst_gndr = 'F' THEN 'Female'
     WHEN cst_gndr = 'M' THEN 'Male'
	 ELSE 'Unknown'
END cst_gndr,     
cst_create_date
FROM [bronze.crm_cust_info]
WHERE cst_lastname IS NOT NULL AND cst_lastname IS NOT NULL


SELECT
DISTINCT cst_marital_status
FROM [bronze.crm_cust_info] 
	




-- Final Transformation Steps

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) As cst_firstname,
TRIM(cst_lastname) As cst_lastname,
CASE WHEN TRIM(cst_marital_status) = 'S' THEN 'Single'
     WHEN TRIM(cst_marital_status) = 'M' THEN 'Married'
	 ELSE 'Unknown'
END cst_marital_status,
CASE WHEN TRIM(cst_gndr) = 'F' THEN 'Female'
     WHEN TRIM(cst_gndr) = 'M' THEN 'Male'
	 ELSE 'Unknown'
END cst_gndr,     
cst_create_date
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_Latest
		FROM [bronze.crm_cust_info])t
		WHERE Flag_Latest =1 AND cst_firstname IS NOT NULL AND cst_lastname IS NOT NULL
		





-- Create & Insert Transformed data to New Table Called crm_customer_info

CREATE TABLE crm_customer_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);

INSERT INTO crm_customer_info (
       cst_id,
	   cst_key,
	   cst_firstname,
	   cst_lastname,
	   cst_marital_status,
	   cst_gndr,
	   cst_create_date)

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) As cst_firstname,
TRIM(cst_lastname) As cst_lastname,
CASE WHEN TRIM(cst_marital_status) = 'S' THEN 'Single'
     WHEN TRIM(cst_marital_status) = 'M' THEN 'Married'
	 ELSE 'Unknown'
END cst_marital_status,
CASE WHEN TRIM(cst_gndr) = 'F' THEN 'Female'
     WHEN TRIM(cst_gndr) = 'M' THEN 'Male'
	 ELSE 'Unknown'
END cst_gndr,     
cst_create_date
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_Latest
		FROM [bronze.crm_cust_info])t
		WHERE Flag_Latest = 1 AND cst_firstname IS NOT NULL AND cst_lastname IS NOT NULL