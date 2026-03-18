
/*	CREATE DATABASE AND SCHEMAS
=========================================================
Script Purpose: This script creates a new Database 'DatabaseWarehouse' after checking if it already exists. Then it proceeds into
createing schemas for 3 layers Bronze, Silver and Gold

Warning: this script will drop entire database 'Datawarehouse' if it exists

*/

USE master;
GO

-- Drop and  recreate Database 'DataWarehouse'

IF EXISTS (SELECT 1 from sys.databases WHERE name= 'DataWarehouse')
BEGIN

	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse
END;

GO

-- Create DataWarehouse

CREATE DATABASE DataWarehouse;

GO

USE DataWarehouse;

GO

-- Create Bronze, silver or Gold schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
