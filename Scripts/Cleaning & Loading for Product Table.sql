--  Checking & Transformation on Product Table

-- Check for Nulls and Duplicates in Primary Key
-- A Primary Key must be Unique and Not Null


SELECT
prd_id,
COUNT(*)
FROM [bronze.crm_prd_info]
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL -- If COUNT show more than 1 for any ID then it is Duplicates or If any NULL it shows.



-- Extract Category Id from Product Key

SELECT
prd_key,
SUBSTRING(prd_key, 1 ,5) AS cat_id -- Category Id is first 5 Character of Product Key
FROM [bronze.crm_prd_info]



-- Extract Product Key from Product Key


SELECT
prd_key,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key -- Product Id starts from 7 onwards Character of Product Key
FROM [bronze.crm_prd_info]


-- Check for Unwanted Spaces

SELECT
prd_nm
FROM [bronze.crm_prd_info]
WHERE prd_nm != TRIM(prd_nm) -- Check for Every Required column


-- Check for Nulls and Negative Numbers

SELECT
prd_cost
FROM [bronze.crm_prd_info]
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Transformation Steps

SELECT
ISNULL(prd_cost, 0) AS prd_cost -- If Business aloow we can replace NULL with Zero
FROM [bronze.crm_prd_info]



-- Data Standardization and Consistency

SELECT 
DISTINCT prd_line
FROM [bronze.crm_prd_info]

-- Transformation Steps
SELECT
CASE WHEN TRIM(prd_line) = 'R' THEN 'Road'
     WHEN TRIM(prd_line) = 'M' THEN 'Mountain'
	 WHEN TRIM(prd_line) = 'S' THEN 'Sales'
	 WHEN TRIM(prd_line) = 'T' THEN 'Touring'
	 ELSE 'Unknown'
END AS prd_line -- Name Change need to confirm from Admin/Client/Expert
FROM [bronze.crm_prd_info]


-- Final Transformation Steps

SELECT
prd_id,
SUBSTRING(prd_key, 1 ,5) AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE WHEN TRIM(prd_line) = 'R' THEN 'Road'
     WHEN TRIM(prd_line) = 'M' THEN 'Mountain'
	 WHEN TRIM(prd_line) = 'S' THEN 'Sales'
	 WHEN TRIM(prd_line) = 'T' THEN 'Touring'
	 ELSE 'Unknown'
END AS prd_line,  -- Name Change need to confirm from Admin/Client/Exper
prd_start_dt,
prd_end_dt
FROM [bronze.crm_prd_info]

-- Create & Insert Transformed data to New Table Called crm_product_info

CREATE TABLE crm_product_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

INSERT INTO crm_product_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt)


SELECT
prd_id,
SUBSTRING(prd_key, 1 ,5) AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE WHEN TRIM(prd_line) = 'R' THEN 'Road'
     WHEN TRIM(prd_line) = 'M' THEN 'Mountain'
	 WHEN TRIM(prd_line) = 'S' THEN 'Sales'
	 WHEN TRIM(prd_line) = 'T' THEN 'Touring'
	 ELSE 'Unknown'
END AS prd_line,  -- Name Change need to confirm from Admin/Client/Exper
prd_start_dt,
prd_end_dt
FROM [bronze.crm_prd_info]