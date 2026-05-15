/*
======================================================================
Stored Procedure: Load Bronze Layer (Source --> Bronze)
======================================================================
Script Turpose:
	This stored procedure loads data into the 'Bronze' schema from external CSF files.
	It performs the following actions:
	- Truncate the bronze tables before loading the data.
	- Uses the 'BULK INSERT' command to load data from CSV files to Bronze tables.

Parameters:
	None
	This stored procedure does not accept any parameters or return any values.

Usage Example:
	EXEC bronze.load_bronze;

*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
	PRINT('==============================================================');
	PRINT('LOADING BRONZE LAYER');
	PRINT('==============================================================');
BEGIN TRY
	SET @batch_start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_cust_info
	BULK INSERT bronze.crm_cust_info 
	FROM 'C:\Data Science\Projects\sql-data-warehouse\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR= ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.crm_prd_info
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Data Science\Projects\sql-data-warehouse\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR= ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.crm_sales_details
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Data Science\Projects\sql-data-warehouse\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR= ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.erp_CUST_AZ12
	BULK INSERT bronze.erp_CUST_AZ12
	FROM 'C:\Data Science\Projects\sql-data-warehouse\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR= ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.erp_LOC_A101
	BULK INSERT bronze.erp_LOC_A101
	FROM 'C:\Data Science\Projects\sql-data-warehouse\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR= ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.erp_PX_CAT_G1V2
	BULK INSERT bronze.erp_PX_CAT_G1V2
	FROM 'C:\Data Science\Projects\sql-data-warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR= ',',
		TABLOCK
	);
	SET @batch_end_time = GETDATE();
	print('Load duration of Bronze layer: ' + CAST(DATEDIFF(millisecond, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' milliseconds.');
END TRY
BEGIN CATCH
	PRINT('Error Occurred !');
	PRINT('Error Message: ' + CAST(ERROR_MESSAGE() AS NVARCHAR));
	PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
END CATCH
END

EXEC bronze.load_bronze;