/*
================================================================================
    Project:        Data Warehouse
    Script Name:    bronze_load.sql
    Description:    Creates a stored procedure to load source CSV files
                    into the Bronze layer of the DataWarehouse database.

                    The procedure performs the following operations:
                    1. Truncates existing data from each Bronze table.
                    2. Loads fresh data from CSV files using BULK INSERT.
                    3. Skips the CSV header row during data loading.
                    4. Uses table-level locking to optimize bulk loading.

    Database:       DataWarehouse
    Layer:          Bronze
    Schema:         bronze

    Stored Procedure:
                    bronze.load_bronze

    Source Systems:
                    CRM - Customer Relationship Management
                    ERP - Enterprise Resource Planning

    Tables Loaded:
                    CRM:
                        - crm_cust_info
                        - crm_prd_info
                        - crm_sales_details

                    ERP:
                        - erp_loc_a101
                        - erp_cust_az12
                        - erp_px_cat_g1v2

    Loading Strategy:
                    Full Load (Truncate and Reload)

    WARNING:
    Every execution removes all existing data from the six Bronze tables
    before loading fresh data from the CSV files.

    Execution:
                    EXEC bronze.load_bronze;

    Requirements:
                    - Bronze tables must already exist.
                    - SQL Server must have access to the CSV source files.
                    - The SQL Server execution context must have the
                      required permissions for BULK INSERT.

================================================================================
*/


/*
================================================================================
    PROCEDURE: bronze.load_bronze
    Description:
        Loads raw data from CRM and ERP CSV source files into the
        corresponding Bronze layer tables.

    Loading Method:
        TRUNCATE TABLE + BULK INSERT

    Note:
        CREATE OR ALTER allows the procedure to be created if it does not
        exist or updated if it already exists.
================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    /*
    ============================================================================
        SECTION 1: LOAD CRM SOURCE DATA
        Source System: Customer Relationship Management (CRM)
    ============================================================================
    */
    PRINT '=========================================';
    PRINT 'Loading Bronze Layer';
    PRINT '=========================================';

    /*
    ---------------------------------------------------------------------------
        TABLE 1: bronze.crm_cust_info
        Source File: cust_info.csv

        Description:
            Loads customer master information from the CRM source system.
    ---------------------------------------------------------------------------
    */

	PRINT '-----------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '-----------------------------------------';
    -- Remove all existing records before performing a full reload.
    TRUNCATE TABLE bronze.crm_cust_info;

    -- Import customer information from the CSV source file.
    BULK INSERT bronze.crm_cust_info
    FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the first row (CSV column headers).
        FIELDTERMINATOR = ',',  -- Separate fields using a comma.
        TABLOCK                 -- Acquire a table-level bulk update lock.
    );


    /*
    ---------------------------------------------------------------------------
        TABLE 2: bronze.crm_prd_info
        Source File: prd_info.csv

        Description:
            Loads product master information from the CRM source system.
    ---------------------------------------------------------------------------
    */

    -- Remove all existing records before performing a full reload.
    TRUNCATE TABLE bronze.crm_prd_info;

    -- Import product information from the CSV source file.
    BULK INSERT bronze.crm_prd_info
    FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the first row (CSV column headers).
        FIELDTERMINATOR = ',',  -- Separate fields using a comma.
        TABLOCK                 -- Acquire a table-level bulk update lock.
    );


    /*
    ---------------------------------------------------------------------------
        TABLE 3: bronze.crm_sales_details
        Source File: sales_details.csv

        Description:
            Loads sales transaction details from the CRM source system.
    ---------------------------------------------------------------------------
    */

    -- Remove all existing records before performing a full reload.
    TRUNCATE TABLE bronze.crm_sales_details;

    -- Import sales transaction details from the CSV source file.
    BULK INSERT bronze.crm_sales_details
    FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the first row (CSV column headers).
        FIELDTERMINATOR = ',',  -- Separate fields using a comma.
        TABLOCK                 -- Acquire a table-level bulk update lock.
    );


    /*
    ============================================================================
        SECTION 2: LOAD ERP SOURCE DATA
        Source System: Enterprise Resource Planning (ERP)
    ============================================================================
    */


    /*
    ---------------------------------------------------------------------------
        TABLE 4: bronze.erp_loc_a101
        Source File: LOC_A101.csv

        Description:
            Loads customer location information from the ERP source system.
    ---------------------------------------------------------------------------
    */
	PRINT '-----------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT '-----------------------------------------';
    -- Remove all existing records before performing a full reload.
    TRUNCATE TABLE bronze.erp_loc_a101;

    -- Import customer location data from the CSV source file.
    BULK INSERT bronze.erp_loc_a101
    FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the first row (CSV column headers).
        FIELDTERMINATOR = ',',  -- Separate fields using a comma.
        TABLOCK                 -- Acquire a table-level bulk update lock.
    );


    /*
    ---------------------------------------------------------------------------
        TABLE 5: bronze.erp_cust_az12
        Source File: CUST_AZ12.csv

        Description:
            Loads additional customer demographic information from
            the ERP source system.
    ---------------------------------------------------------------------------
    */

    -- Remove all existing records before performing a full reload.
    TRUNCATE TABLE bronze.erp_cust_az12;

    -- Import customer demographic data from the CSV source file.
    BULK INSERT bronze.erp_cust_az12
    FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the first row (CSV column headers).
        FIELDTERMINATOR = ',',  -- Separate fields using a comma.
        TABLOCK                 -- Acquire a table-level bulk update lock.
    );


    /*
    ---------------------------------------------------------------------------
        TABLE 6: bronze.erp_px_cat_g1v2
        Source File: PX_CAT_G1V2.csv

        Description:
            Loads product category and maintenance information from
            the ERP source system.
    ---------------------------------------------------------------------------
    */

    -- Remove all existing records before performing a full reload.
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    -- Import product category data from the CSV source file.
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the first row (CSV column headers).
        FIELDTERMINATOR = ',',  -- Separate fields using a comma.
        TABLOCK                 -- Acquire a table-level bulk update lock.
    );

END;
GO


/*
================================================================================
    END OF PROCEDURE
    bronze.load_bronze

    Execution Example:
        EXEC bronze.load_bronze;

    Expected Result:
        All six Bronze tables are truncated and reloaded with fresh
        data from their corresponding CRM and ERP CSV source files.
================================================================================
*/
