/*
Create database and schemas
---------------------------------------
-- Script Purpose
This script ceeates a new database named 'DataWarehouse' after checking if it already exists. If the database exists, it is dropped and recreated. 
Additionally the script set up three schemas within the database: bronze, silver, gold.
----------------------------------------------------------------------------------------------------------------------------------------------------
*/

Use master;
Go

-- Drop and recreate  the 'Datawarehouse' database.
	if exists (select 1 from sys.databases where name = 'Datawarehouse')
	begin
		alter database DataWarehouse set single_user with rollback immediate;
		drop database DataWarehouse;
end;
go

-- Create the 'DataWarehouse' database.
	create database DataWarehouse;
	go

	use DataWarehouse;
	go

	-- Create schemas
		create schema bronze;
		go
		create schema silver;
		go
		create schema gold;
		go


