--The WHERE Clause
USE AdventureWorks2014;
GO

/*
gjgjhgjg
Comments
*/
--a one line comment

--=, <> , etc
SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName = 'Smith';

SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName <> 'Smith';

SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName > 'C';


SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName > 'Cai';

SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName >= 'Cai';

SELECT SalesOrderID 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID > 75120;

SELECT SalesOrderID 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID >= 75120;

--LIKE
SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName LIKE 'sm%';

SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName LIKE '%s';

SELECT LastName
	,FirstName 
FROM Person.Person 
WHERE LastName LIKE '%bb%';

--in
SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName IN ('Calafato','Caldwell');


--BETWEEN
SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName BETWEEN 'A' AND 'C';

SELECT SalesOrderID 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID BETWEEN 75120 AND 75122;

--NOT
SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName NOT BETWEEN 'B' AND 'C';

SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName NOT IN ('Calafato','Caldwell');

--AND OR
SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName = 'Adams' AND FirstName = 'Adam';

SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName = 'Adams' OR FirstName = 'Adam';

--Find the people with last name Adams. The first name could be Adam or Aaron
--57 rows
SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName = 'Adams' 
	AND FirstName = 'Adam' OR FirstName = 'Aaron';

--54 rows
SELECT LastName, FirstName 
FROM Person.Person 
WHERE FirstName = 'Adam' OR FirstName = 'Aaron'
	AND LastName = 'Adams';

--Best way to write
SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName = 'Adams' 
	AND (FirstName = 'Adam' OR FirstName = 'Aaron');

--In this case, can also do this
SELECT LastName, FirstName 
FROM Person.Person 
WHERE LastName = 'Adams' 
	AND FirstName  IN ('Adam','Aaron');

--NULL = UNKNOWN
--How many products? 504
SELECT ProductID, Name, Color, Size 
FROM Production.Product;

--How many are blue? 26
SELECT ProductID, Name, Color, Size 
FROM Production.Product
WHERE Color = 'Blue';

--How many are not blue? 230
SELECT ProductID, Name, Color, Size 
FROM Production.Product
WHERE Color <> 'Blue';

--One solution 478
SELECT ProductID, Name, Color, Size 
FROM Production.Product
WHERE Color <> 'Blue' OR Color IS NULL;

--Other solutions
SELECT ProductID, Name, Color, Size 
FROM Production.Product
WHERE ISNULL(Color,'') <> 'Blue';

SELECT ProductID, Name, Color, Size 
FROM Production.Product
WHERE COALESCE(Color,'') <> 'Blue';

--Other ways to use COALESCE
SELECT ProductID, Name, Size, Color, COALESCE(Size,Color,'N/A') AS 'Desc'
FROM Production.Product
WHERE COALESCE(Color,'') <> 'Blue';




