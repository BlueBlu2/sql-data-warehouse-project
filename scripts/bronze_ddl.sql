
/*
================================================================================
    Project:        Data Warehouse
    Script Name:    bronze_ddl.sql
    Description:    Creates the Bronze layer tables in the DataWarehouse
                    database.

                    The script performs the following operations:
                    1. Checks whether each Bronze table already exists.
                    2. Drops existing tables to allow a fresh initialization.
                    3. Creates empty tables based on the source system structure.

    Layer:          Bronze
    Database:       DataWarehouse
    Schema:         bronze

    Source Systems:
                    CRM - Customer Relationship Management
                    ERP - Enterprise Resource Planning

    Tables Created:
                    CRM:
                        - crm_cust_info
                        - crm_prd_info
                        - crm_sales_details

                    ERP:
                        - erp_loc_a101
                        - erp_cust_az12
                        - erp_px_cat_g1v2

    WARNING:
    This script permanently drops existing tables and their data before
    recreating them.

    Execution:      Run after initializing the DataWarehouse database
                    and creating the Bronze schema.
================================================================================
*/


/*
================================================================================
    SECTION 1: CRM SOURCE TABLES
    Source System: Customer Relationship Management (CRM)
================================================================================
*/


/*
--------------------------------------------------------------------------------
    TABLE 1: bronze.crm_cust_info
    Description: Stores customer master information from the CRM system.

    Columns:
        cst_id              - Unique customer identifier.
        cst_key             - Customer business key.
        cst_firstname       - Customer first name.
        cst_lastname        - Customer last name.
        cst_marital_status  - Customer marital status.
        cst_gndr            - Customer gender.
        cst_create_date     - Date the customer record was created.
--------------------------------------------------------------------------------
*/

-- Check whether the customer information table already exists.
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL

    -- Drop the existing table to ensure a clean recreation.
    DROP TABLE bronze.crm_cust_info;
GO

-- Create the CRM customer information table.
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,            -- Customer identifier
    cst_key             NVARCHAR(50),   -- Customer business key
    cst_firstname       NVARCHAR(50),   -- Customer first name
    cst_lastname        NVARCHAR(50),   -- Customer last name
    cst_marital_status  NVARCHAR(50),   -- Customer marital status
    cst_gndr            NVARCHAR(50),   -- Customer gender
    cst_create_date     DATE            -- Customer creation date
);
GO


/*
--------------------------------------------------------------------------------
    TABLE 2: bronze.crm_prd_info
    Description: Stores product master information from the CRM system.

    Columns:
        prd_id       - Unique product identifier.
        prd_key      - Product business key.
        prd_nm       - Product name.
        prd_cost     - Product cost.
        prd_line     - Product line or category.
        prd_start_dt - Product validity start date.
        prd_end_dt   - Product validity end date.
--------------------------------------------------------------------------------
*/

-- Check whether the product information table already exists.
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL

    -- Drop the existing table to ensure a clean recreation.
    DROP TABLE bronze.crm_prd_info;
GO

-- Create the CRM product information table.
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,            -- Product identifier
    prd_key      NVARCHAR(50),   -- Product business key
    prd_nm       NVARCHAR(50),   -- Product name
    prd_cost     INT,            -- Product cost
    prd_line     NVARCHAR(50),   -- Product line
    prd_start_dt DATETIME,       -- Product validity start date
    prd_end_dt   DATETIME        -- Product validity end date
);
GO


/*
--------------------------------------------------------------------------------
    TABLE 3: bronze.crm_sales_details
    Description: Stores sales transaction details from the CRM system.

    Columns:
        sls_ord_num  - Sales order number.
        sls_prd_key  - Product business key associated with the sale.
        sls_cust_id  - Customer identifier associated with the sale.
        sls_order_dt - Order date (stored as an integer).
        sls_ship_dt  - Shipping date (stored as an integer).
        sls_due_dt   - Due date (stored as an integer).
        sls_sales    - Sales amount.
        sls_quantity - Quantity sold.
        sls_price    - Unit selling price.
--------------------------------------------------------------------------------
*/

-- Check whether the sales details table already exists.
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL

    -- Drop the existing table to ensure a clean recreation.
    DROP TABLE bronze.crm_sales_details;
GO

-- Create the CRM sales details table.
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),   -- Sales order number
    sls_prd_key  NVARCHAR(50),   -- Product business key
    sls_cust_id  INT,            -- Customer identifier
    sls_order_dt INT,            -- Order date (integer format)
    sls_ship_dt  INT,            -- Shipping date (integer format)
    sls_due_dt   INT,            -- Due date (integer format)
    sls_sales    INT,            -- Sales amount
    sls_quantity INT,            -- Quantity sold
    sls_price    INT             -- Unit selling price
);
GO


/*
================================================================================
    SECTION 2: ERP SOURCE TABLES
    Source System: Enterprise Resource Planning (ERP)
================================================================================
*/


/*
--------------------------------------------------------------------------------
    TABLE 4: bronze.erp_loc_a101
    Description: Stores customer location information from the ERP system.

    Columns:
        cid   - Customer identifier.
        cntry - Customer country.
--------------------------------------------------------------------------------
*/

-- Check whether the customer location table already exists.
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL

    -- Drop the existing table to ensure a clean recreation.
    DROP TABLE bronze.erp_loc_a101;
GO

-- Create the ERP customer location table.
CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),   -- Customer identifier
    cntry  NVARCHAR(50)    -- Customer country
);
GO


/*
--------------------------------------------------------------------------------
    TABLE 5: bronze.erp_cust_az12
    Description: Stores additional customer demographic information
                 from the ERP system.

    Columns:
        cid   - Customer identifier.
        bdate - Customer birth date.
        gen   - Customer gender.
--------------------------------------------------------------------------------
*/

-- Check whether the customer demographics table already exists.
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL

    -- Drop the existing table to ensure a clean recreation.
    DROP TABLE bronze.erp_cust_az12;
GO

-- Create the ERP customer demographics table.
CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),   -- Customer identifier
    bdate  DATE,           -- Customer birth date
    gen    NVARCHAR(50)    -- Customer gender
);
GO


/*
--------------------------------------------------------------------------------
    TABLE 6: bronze.erp_px_cat_g1v2
    Description: Stores product category and maintenance information
                 from the ERP system.

    Columns:
        id          - Product identifier or product-related key.
        cat         - Product category.
        subcat      - Product subcategory.
        maintenance - Product maintenance information.
--------------------------------------------------------------------------------
*/

-- Check whether the product categories table already exists.
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL

    -- Drop the existing table to ensure a clean recreation.
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

-- Create the ERP product categories table.
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),   -- Product identifier or related key
    cat          NVARCHAR(50),   -- Product category
    subcat       NVARCHAR(50),   -- Product subcategory
    maintenance  NVARCHAR(50)    -- Maintenance information
);
GO


/*
================================================================================
    END OF SCRIPT
    All Bronze layer source tables have been initialized successfully.
================================================================================
*/
