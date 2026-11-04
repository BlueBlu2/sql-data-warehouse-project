/*
================================================================================
    Project:        Data Warehouse
    Script Name:    init_database.sql
    Description:    Initializes the Data Warehouse environment by:
                    1. Checking whether the DataWarehouse database exists.
                    2. Dropping the existing database if found.
                    3. Creating a new DataWarehouse database.
                    4. Creating the Bronze, Silver, and Gold schemas.

    Database:       DataWarehouse
    Schemas:        bronze, silver, gold

    WARNING:
    This script permanently deletes the existing DataWarehouse database
    and all its data before recreating it.

    Execution:      Run with sufficient SQL Server administrative privileges.
    SQL Server:     Microsoft SQL Server
================================================================================
*/


/*
================================================================================
    STEP 1: Switch to the Master Database
================================================================================
*/

-- Switch the current database context to master.
-- This is necessary because the target database may be dropped.
USE master;
GO


/*
================================================================================
    STEP 2: Drop the Existing Data Warehouse Database
================================================================================
*/

-- Check whether the DataWarehouse database already exists.
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN

    -- Set the database to SINGLE_USER mode.
    -- ROLLBACK IMMEDIATE terminates existing connections
    -- and rolls back any active transactions.
    -- This ensures the database can be dropped without connection conflicts.
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    -- Permanently delete the existing DataWarehouse database.
    DROP DATABASE DataWarehouse;

END;
GO


/*
================================================================================
    STEP 3: Create a New Data Warehouse Database
================================================================================
*/

-- Create a fresh database named DataWarehouse.
CREATE DATABASE DataWarehouse;

-- Switch the current database context to the newly created database.
USE DataWarehouse;
GO


/*
================================================================================
    STEP 4: Create the Data Warehouse Schemas
================================================================================
*/

-- Create the Bronze layer.
-- Purpose: Stores raw data ingested from source systems.
CREATE SCHEMA bronze;
GO

-- Create the Silver layer.
-- Purpose: Stores cleaned, standardized, and transformed data.
CREATE SCHEMA silver;
GO

-- Create the Gold layer.
-- Purpose: Stores business-ready, aggregated, and analytical data.
CREATE SCHEMA gold;
GO


/*
================================================================================
    END OF SCRIPT
    Data Warehouse database initialization completed.
================================================================================
*/
