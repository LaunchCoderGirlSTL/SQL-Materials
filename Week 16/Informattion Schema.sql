--Find all functions and stored procedures
SELECT * FROM INFORMATION_SCHEMA.ROUTINES;

--Find all views
SELECT * FROM INFORMATION_SCHEMA.VIEWS;

--Search for specific columns
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'CustomerID';

--Find all columns of a specific data type
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'XML';

--Using system objects
SELECT * FROM sys.objects;