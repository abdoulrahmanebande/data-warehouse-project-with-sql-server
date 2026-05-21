/*
===================================================================================
Quality Checks
===================================================================================
Script Purpose:
  This script performs various quality checks to validate the integrity, consistency
  and accuracy of the Gold layer. These checks ensure: 
  - Uniqueness of surrogate keys in dimension tables.
  - Referential integrity between fact and dimension tables.
  - Validation of relationships in the data model for analytical purposes.

  Usage Notes:
  - Run these checks after loading the data in the Silver layer
*/

-- Quality Check: No duplicate cst_id should be found because it will be used later to join
-- with the sales table
-- Expectation: No result
SELECT cst_id, COUNT(*)
FROM (
	SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ca.BDATE,
	la.CNTRY,
	ci.cst_marital_status,
	ci.cst_gndr, 
	ca.GEN,
	ci.cst_create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 AS ca
ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 AS la
ON ci.cst_key = la.CID
)t GROUP BY cst_id HAVING COUNT(*) > 1

-- Check the gold.dim_customers View
SELECT * FROM gold.dim_customers;

-- Quality Check: No duplicate prd_key should be found because it will be used later to join
-- with the sales table
-- Expectation: No result
SELECT prd_key, COUNT(*)
FROM (
	SELECT
		pi.prd_id,
		pi.prd_key,
		pi.cat_id,
		pi.prd_nm,
		pc.CAT,
		pc.SUBCAT,
		pc.MAINTENANCE,
		pi.prd_cost, 
		pi.prd_line,
		pi.prd_start_dt
	FROM silver.crm_prd_info AS pi 
	LEFT JOIN silver.erp_PX_CAT_G1V2 AS pc
	ON pi.cat_id = pc.ID
	WHERE pi.prd_end_dt IS NULL -- Filtering out historical data (old products)
)t GROUP BY prd_key HAVING COUNT(*) > 1

-- Check the gold.dim_products View
SELECT * FROM gold.dim_products;

-- Quality Check: Check to see if we can connect the Dimension tables with 
-- the Fact table
SELECT * 
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

SELECT * 
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.product_key IS NULL