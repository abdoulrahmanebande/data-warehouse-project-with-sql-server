/*
==========================================================================
DDL Script: Create Gold Views
==========================================================================
Script Purpose:
  This script creates Views for the Gold layer in the data warehouse.
  The Gold layer represents the final dimension and fact tables (Star schema).

  Each View performs transformations and combines data from the Silver layer
  to produce a clean, enriched and business-ready dataset.

  Usage:
    These Views can be queried directly for Analytics and Reporting.
*/

-- ======================================================
-- Create Dimension: gold.dim_customers
-- ======================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL 
	DROP VIEW gold.dim_customers
GO
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key, -- Surrogate Key
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ca.BDATE AS birth_date,
	la.CNTRY AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr IS NOT NULL THEN ci.cst_gndr
		 ELSE COALESCE(ca.GEN, 'n/a')
	END AS gender,
	ci.cst_create_date AS  create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 AS ca
ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 AS la
ON ci.cst_key = la.CID;

GO
-- ======================================================
-- Create Dimension: gold.dim_products
-- ======================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY prd_key, prd_start_dt) AS product_key,
	pi.prd_id AS product_id,
	pi.prd_key AS product_number,
	pi.cat_id AS category_id,
	pi.prd_nm AS product_name,
	pc.CAT AS category,
	pc.SUBCAT AS sub_category,
	pc.MAINTENANCE AS maintenance,
	pi.prd_cost AS cost, 
	pi.prd_line AS product_line,
	pi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pi 
LEFT JOIN silver.erp_PX_CAT_G1V2 AS pc
ON pi.cat_id = pc.ID
WHERE pi.prd_end_dt IS NULL -- Filtering out historical data (old products)

GO 

-- ======================================================
-- Create Fact: gold.dim_customers
-- ======================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT 
	sd.sls_ord_num,
	c.customer_key,
	p.product_key,
	sd.sls_prd_key,
	sd.sls_cust_id,
	sd.sls_order_dt,
	sd.sls_ship_dt,
	sd.sls_due_dt,
	sd.sls_sales,
	sd.sls_quantity,
	sd.sls_price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_customers AS c
ON sd.sls_cust_id = c.customer_id
LEFT JOIN gold.dim_products AS p
ON sd.sls_prd_key = p.product_number

