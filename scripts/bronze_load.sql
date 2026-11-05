/*
================================================================================
    Project:        Data Warehouse
    Script Name:    bronze_load.sql

    Description:
        Creates a stored procedure responsible for loading raw source data
        from CRM and ERP CSV files into the Bronze layer.

        The procedure performs the following operations:
            1. Truncates existing data from Bronze tables.
            2. Loads fresh data using BULK INSERT.
            3. Logs loading progress for each table.
            4. Measures individual table loading durations.
            5. Measures total Bronze layer loading duration.
            6. Handles runtime errors using TRY...CATCH.
            7. Displays detailed SQL Server error information.

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

    Logging:
                    PRINT statements
                    GETDATE()
                    DATEDIFF()

    Error Handling:
                    TRY...CATCH
                    ERROR_MESSAGE()
                    ERROR_NUMBER()
                    ERROR_STATE()
                    THROW

    Execution:
                    EXEC bronze.load_bronze;

    WARNING:
        Every execution removes all existing records from the six Bronze
        tables before loading fresh data.

    Requirements:
        - Bronze tables must already exist.
        - SQL Server must have access to the source CSV files.
        - Required BULK INSERT permissions must be available.

================================================================================
*/


/*
================================================================================
    PROCEDURE: bronze.load_bronze

    Description:
        Loads raw data from CRM and ERP source files into Bronze tables.

    Main Components:
        1. Variable Declaration
        2. TRY Block
        3. CRM Data Loading
        4. ERP Data Loading
        5. Batch Execution Summary
        6. CATCH Block

================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    /*
    ============================================================================
        STEP 1: DECLARE EXECUTION TIME VARIABLES
    ============================================================================
    */

    -- Stores the start and end time of each individual table load.
    DECLARE @start_time DATETIME,
            @end_time DATETIME,

            -- Stores the start and end time of the entire loading batch.
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;


    /*
    ============================================================================
        STEP 2: BEGIN ERROR HANDLING
    ============================================================================
    */

    -- TRY block contains the entire Bronze loading process.
    -- If a runtime error occurs, execution moves to the CATCH block.
    BEGIN TRY

        -- Display the beginning of the Bronze loading process.
        PRINT '=========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=========================================';


        /*
        ========================================================================
            SECTION 1: LOAD CRM SOURCE DATA
            Source System: Customer Relationship Management (CRM)
        ========================================================================
        */

        PRINT '-----------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------';


        -- Record the starting time of the entire Bronze loading batch.
        SET @batch_start_time = GETDATE();


        /*
        ------------------------------------------------------------------------
            TABLE 1: bronze.crm_cust_info
            Source File: cust_info.csv

            Description:
                Loads customer master information from the CRM system.
        ------------------------------------------------------------------------
        */

        -- Display the table truncation operation.
        PRINT '>> Truncating Table: crm_cust_info';

        -- Record the start time of the current table loading operation.
        SET @start_time = GETDATE();

        -- Remove all existing customer records before reloading.
        TRUNCATE TABLE bronze.crm_cust_info;

        -- Display the data insertion operation.
        PRINT '>> Inserting Data Into: crm_cust_info';

        -- Load customer information from the CSV source file.
        BULK INSERT bronze.crm_cust_info
        FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the CSV header row.
            FIELDTERMINATOR = ',',  -- Use comma as the column delimiter.
            TABLOCK                 -- Acquire a table-level bulk update lock.
        );

        -- Record the end time of the current table loading operation.
        SET @end_time = GETDATE();

        -- Calculate and display the duration of the customer table load.
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR)
            + ' millisecond'
            + CHAR(10) + CHAR(10) + CHAR(10);


        /*
        ------------------------------------------------------------------------
            TABLE 2: bronze.crm_prd_info
            Source File: prd_info.csv

            Description:
                Loads product master information from the CRM system.
        ------------------------------------------------------------------------
        */

        -- Display the table truncation operation.
        PRINT '>> Truncating Table: crm_prd_info';

        -- Record the start time of the current table loading operation.
        SET @start_time = GETDATE();

        -- Remove all existing product records before reloading.
        TRUNCATE TABLE bronze.crm_prd_info;

        -- Display the data insertion operation.
        PRINT '>> Inserting Data Into: crm_prd_info';

        -- Load product information from the CSV source file.
        BULK INSERT bronze.crm_prd_info
        FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the CSV header row.
            FIELDTERMINATOR = ',',  -- Use comma as the column delimiter.
            TABLOCK                 -- Acquire a table-level bulk update lock.
        );

        -- Record the end time of the current table loading operation.
        SET @end_time = GETDATE();

        -- Calculate and display the duration of the product table load.
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR)
            + ' millisecond'
            + CHAR(10) + CHAR(10) + CHAR(10);


        /*
        ------------------------------------------------------------------------
            TABLE 3: bronze.crm_sales_details
            Source File: sales_details.csv

            Description:
                Loads sales transaction details from the CRM system.
        ------------------------------------------------------------------------
        */

        -- Display the table truncation operation.
        PRINT '>> Truncating Table: crm_sales_details';

        -- Record the start time of the current table loading operation.
        SET @start_time = GETDATE();

        -- Remove all existing sales records before reloading.
        TRUNCATE TABLE bronze.crm_sales_details;

        -- Display the data insertion operation.
        PRINT '>> Inserting Data Into: crm_sales_details';

        -- Load sales transaction details from the CSV source file.
        BULK INSERT bronze.crm_sales_details
        FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the CSV header row.
            FIELDTERMINATOR = ',',  -- Use comma as the column delimiter.
            TABLOCK                 -- Acquire a table-level bulk update lock.
        );

        -- Record the end time of the current table loading operation.
        SET @end_time = GETDATE();

        -- Calculate and display the duration of the sales table load.
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR)
            + ' millisecond'
            + CHAR(10) + CHAR(10) + CHAR(10);


        /*
        ========================================================================
            SECTION 2: LOAD ERP SOURCE DATA
            Source System: Enterprise Resource Planning (ERP)
        ========================================================================
        */

        PRINT '-----------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------';


        /*
        ------------------------------------------------------------------------
            TABLE 4: bronze.erp_loc_a101
            Source File: LOC_A101.csv

            Description:
                Loads customer location information from the ERP system.
        ------------------------------------------------------------------------
        */

        -- Display the table truncation operation.
        PRINT '>> Truncating Table: erp_loc_a101';

        -- Record the start time of the current table loading operation.
        SET @start_time = GETDATE();

        -- Remove all existing customer location records before reloading.
        TRUNCATE TABLE bronze.erp_loc_a101;

        -- Display the data insertion operation.
        PRINT '>> Inserting Data Into: erp_loc_a101';

        -- Load customer location data from the CSV source file.
        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the CSV header row.
            FIELDTERMINATOR = ',',  -- Use comma as the column delimiter.
            TABLOCK                 -- Acquire a table-level bulk update lock.
        );

        -- Record the end time of the current table loading operation.
        SET @end_time = GETDATE();

        -- Calculate and display the duration of the location table load.
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR)
            + ' millisecond'
            + CHAR(10) + CHAR(10) + CHAR(10);


        /*
        ------------------------------------------------------------------------
            TABLE 5: bronze.erp_cust_az12
            Source File: CUST_AZ12.csv

            Description:
                Loads additional customer demographic information
                from the ERP system.
        ------------------------------------------------------------------------
        */

        -- Display the table truncation operation.
        PRINT '>> Truncating Table: erp_cust_az12';

        -- Record the start time of the current table loading operation.
        SET @start_time = GETDATE();

        -- Remove all existing customer demographic records before reloading.
        TRUNCATE TABLE bronze.erp_cust_az12;

        -- Display the data insertion operation.
        PRINT '>> Inserting Data Into: erp_cust_az12';

        -- Load customer demographic data from the CSV source file.
        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the CSV header row.
            FIELDTERMINATOR = ',',  -- Use comma as the column delimiter.
            TABLOCK                 -- Acquire a table-level bulk update lock.
        );

        -- Record the end time of the current table loading operation.
        SET @end_time = GETDATE();

        -- Calculate and display the duration of the demographics table load.
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR)
            + ' millisecond'
            + CHAR(10) + CHAR(10) + CHAR(10);


        /*
        ------------------------------------------------------------------------
            TABLE 6: bronze.erp_px_cat_g1v2
            Source File: PX_CAT_G1V2.csv

            Description:
                Loads product category and maintenance information
                from the ERP system.
        ------------------------------------------------------------------------
        */

        -- Display the table truncation operation.
        PRINT '>> Truncating Table: erp_px_cat_g1v2';

        -- Record the start time of the current table loading operation.
        SET @start_time = GETDATE();

        -- Remove all existing product category records before reloading.
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        -- Display the data insertion operation.
        PRINT '>> Inserting Data Into: erp_px_cat_g1v2';

        -- Load product category data from the CSV source file.
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\Work\code\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the CSV header row.
            FIELDTERMINATOR = ',',  -- Use comma as the column delimiter.
            TABLOCK                 -- Acquire a table-level bulk update lock.
        );

        -- Record the end time of the current table loading operation.
        SET @end_time = GETDATE();

        -- Calculate and display the duration of the product category table load.
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR)
            + ' millisecond'
            + CHAR(10) + CHAR(10) + CHAR(10);


        /*
        ========================================================================
            STEP 3: CALCULATE TOTAL BATCH EXECUTION DURATION
        ========================================================================
        */

        -- Record the ending time of the entire Bronze loading batch.
        SET @batch_end_time = GETDATE();

        -- Display the completion message.
        PRINT '=========================================';
        PRINT 'Loading Bronze Layer is Completed ';

        -- Calculate and display the total execution duration.
        PRINT '    - Total Load Duration: '
            + CAST(
                DATEDIFF(MILLISECOND, @batch_start_time, @batch_end_time)
                AS NVARCHAR
              )
            + ' millisecond' + CHAR(10);

        PRINT '=========================================';


    END TRY


    /*
    ============================================================================
        STEP 4: ERROR HANDLING
    ============================================================================
    */

    BEGIN CATCH

        -- Display an error notification.
        PRINT '=========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';

        -- Retrieve and display the SQL Server error message.
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();

        -- Retrieve and display the SQL Server error number.
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

        -- Retrieve and display the SQL Server error state.
        PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);

        PRINT '=========================================';

        -- Rethrow the original error so that the calling application
        -- or execution environment can detect the procedure failure.
        THROW;

    END CATCH

END;
GO


/*
================================================================================
    END OF SCRIPT
    Stored Procedure: bronze.load_bronze

    Execution Example:
        EXEC bronze.load_bronze;

    Expected Result:
        - All six Bronze tables are truncated and reloaded.
        - Loading progress is displayed for CRM and ERP tables.
        - Individual table loading durations are calculated.
        - Total batch execution duration is calculated.
        - Runtime errors are captured and propagated to the caller.

================================================================================
*/
