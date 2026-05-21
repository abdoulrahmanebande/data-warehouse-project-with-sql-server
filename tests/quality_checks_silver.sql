/*
======================================================================
Quality Checks
======================================================================
Script Turpose:
	This script performs various quality checks for data consistency, accuracy
  and standardization across the 'silver' schema. It includes checks for:
	- Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standardization and consistency.
  - Invalid data range and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these only after loading the data into the Silver layer.
	- Investigate and resolve any discrepancies found during the checks.
	- Investigate and resolve any discrepancies found during the checks.

*/

-- ==========================================================================
-- Quality checks for crm_cust_info table
-- ==========================================================================

-- Check for duplicates customer id
-- Expectation: No result
SELECT
	cst_id,
	COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id = NULL

-- Check unwanted spaces for customer key column
-- Expectation: No result
SELECT 
	cst_key 
FROM silver.crm_cust_info WHERE LEN(cst_key) != LEN(TRIM(cst_key))

-- Check unwanted spaces for customer first name column
-- Expectation: No result
SELECT 
	cst_firstname
FROM silver.crm_cust_info WHERE LEN(cst_firstname) != LEN(TRIM(cst_firstname))

-- Check unwanted spaces for customer last name column
-- Expectation: No result
SELECT 
	cst_firstname
FROM silver.crm_cust_info WHERE LEN(cst_lastname) != LEN(TRIM(cst_lastname))

-- Normalization for customer marital status
SELECT DISTINCT
	cst_marital_status
FROM silver.crm_cust_info

-- Normalization for customer gender
SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info

-- ==========================================================================
-- Quality checks for crm_prd_info table
-- ==========================================================================

-- Check for duplicates product id
SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check unwanted spaces for product name column
-- Expectation: No result
SELECT 
	prd_nm
FROM silver.crm_prd_info WHERE LEN(prd_nm) != LEN(TRIM(prd_nm))

-- Check for invalid product cost
-- Expectation: No result
SELECT 
	prd_cost
FROM silver.crm_prd_info WHERE prd_cost IS NULL

-- Normalization for product line
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info

-- ==========================================================================
-- Quality checks for crm_sales_details table
-- ==========================================================================
-- Check unwanted spaces for sales order number column
-- Expectation: No result
SELECT 
	sls_ord_num
FROM silver.crm_sales_details WHERE LEN(sls_ord_num) != LEN(TRIM(sls_ord_num))

-- Check unwanted spaces for sales product key column
-- Expectation: No result
SELECT 
	sls_prd_key
FROM silver.crm_sales_details WHERE LEN(sls_prd_key) != LEN(TRIM(sls_prd_key))

-- Check for invalid sales order dates
-- Expectation: No result
SELECT 
	sls_order_dt
FROM bronze.crm_sales_details WHERE sls_order_dt = 0 OR LEN(sls_order_dt) != 8 OR sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt

-- Check for invalid sales due dates
-- Expectation: No result
SELECT 
	sls_due_dt
FROM bronze.crm_sales_details WHERE sls_due_dt = 0 OR LEN(sls_due_dt) != 8 OR sls_ship_dt > sls_due_dt OR sls_order_dt > sls_due_dt

-- Check for invalid sales, quantity and price values
-- Expectation: No result
SELECT 
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales <= 0 OR sls_sales IS NULL OR 
	  sls_quantity <= 0 OR sls_quantity IS NULL OR
	  sls_price <= 0 OR sls_price IS NULL OR
	  sls_sales != sls_price * sls_quantity
ORDER BY sls_sales, sls_quantity, sls_price

-- ==========================================================================
-- Quality checks for erp_CUST_AZ12 table
-- ==========================================================================

-- Check for invalid customer birthdates column
-- Expectation: No result
SELECT
	BDATE
FROM silver.erp_CUST_AZ12 WHERE BDATE >= GETDATE();

-- Standardization of customer gender column
SELECT DISTINCT
	GEN 
FROM silver.erp_CUST_AZ12

-- ==========================================================================
-- Quality checks for erp_LOC_A101 table
-- ==========================================================================

-- Standardization of customer gender column
SELECT DISTINCT
	CNTRY
FROM silver.erp_LOC_A101

-- ==========================================================================
-- Quality checks for erp_PX_CAT_G1V2 table
-- ==========================================================================

-- Check for unwanted spaces from the ID string column
SELECT 
	*
FROM silver.erp_PX_CAT_G1V2 WHERE LEN(ID) != LEN(TRIM(ID))

-- Standardization of product category column
SELECT DISTINCT
	CAT
FROM silver.erp_PX_CAT_G1V2;

-- Standardization of product sub-category column
SELECT DISTINCT
	SUBCAT
FROM silver.erp_PX_CAT_G1V2;

-- Standardization of product maintenance column
SELECT DISTINCT
	MAINTENANCE
FROM silver.erp_PX_CAT_G1V2;

-- Checking for unwanted spaces in product category, sub-category and maintenance columns
SELECT 
	*
FROM silver.erp_PX_CAT_G1V2 WHERE LEN(CAT) != LEN(TRIM(CAT)) OR 
								  LEN(SUBCAT) != LEN(TRIM(SUBCAT)) OR 
								  LEN(MAINTENANCE) != LEN(TRIM(MAINTENANCE))