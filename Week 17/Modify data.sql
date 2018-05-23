--Inserting data 


--Create a table for practice!
DROP TABLE IF EXISTS dbo.Customers;
GO 
CREATE TABLE dbo.Customers(
	CustomerID INT NOT NULL IDENTITY PRIMARY KEY,--Auto populates!
	FirstName NVARCHAR(50) NOT NULL, 
	MiddleName NVARCHAR(50) NULL, 
	LastName NVARCHAR(50) NULL, 
	Active BIT DEFAULT 1);
GO
SELECT * FROM dbo.Customers;

--Insert hard-coded values
INSERT INTO dbo.Customers
(        FirstName, MiddleName, LastName)
VALUES
		(N'Ken',    N'J',       N'Sánchez'),
		(N'Terri',  N'Lee',     N'Duffy'),
		(N'Roberto',NULL,       N'Tamburello');

SELECT * FROM dbo.Customers;

--Another way to insert that's used a lot!
INSERT INTO dbo.Customers
(   FirstName, MiddleName, LastName)
SELECT
    N'Rob',    NULL,       N'Walters'
UNION ALL 
SELECT
	N'Gail',   N'A',       N'Erickson';

--Insert from a query
INSERT INTO dbo.Customers
		(FirstName, MiddleName, LastName)
SELECT TOP(10) FirstName, MiddleName, LastName 
FROM Person.Person  --Often checks to make sure that the row doesn't exist
WHERE BusinessEntityID NOT IN(SELECT CustomerID FROM dbo.Customers);

SELECT * FROM dbo.Customers;

--Skip NULL column
INSERT INTO dbo.Customers
		(FirstName,  LastName)
SELECT TOP(10) FirstName, LastName 
FROM Person.Person  --Often checks to make sure that the row doesn't exist
WHERE BusinessEntityID NOT IN(SELECT CustomerID FROM dbo.Customers);


SELECT * FROM dbo.Customers;

--Try to insert the CustomerID value
INSERT INTO dbo.Customers
		(CustomerID, FirstName, MiddleName, LastName)
SELECT TOP(10) BusinessEntityID, FirstName, MiddleName, LastName 
FROM Person.Person  --Often checks to make sure that the row doesn't exist
WHERE BusinessEntityID NOT IN(SELECT CustomerID FROM dbo.Customers);

--Get the IDENTITY value 
SELECT @@IDENTITY, SCOPE_IDENTITY();


--Create a sales table 
DROP TABLE IF EXISTS dbo.Sales
CREATE TABLE dbo.Sales(
	OrderID INT NOT NULL PRIMARY KEY,
	CustomerID INT NOT NULL, 
	OrderDate DATE NOT NULL,
	TotalDue MONEY NOT NULL, 
	);

--Add a foreign key
ALTER TABLE dbo.Sales  WITH CHECK ADD  CONSTRAINT 
	[FK_Sales_Customers] FOREIGN KEY([CustomerID])
REFERENCES dbo.Customers ([CustomerID]);
GO

--Insert a row into the Sales table
INSERT INTO dbo.Sales(OrderID, CustomerID, OrderDate, TotalDue)
VALUES(1,1,GETDATE(),100);

--Insert a bad CustomerID row into the Sales table
INSERT INTO dbo.Sales(OrderID, CustomerID, OrderDate, TotalDue)
VALUES(2,100,GETDATE(),100);

--Try to drop the customer table
DROP TABLE IF EXISTS dbo.Customers;

--Insert a duplicate OrderID
INSERT INTO dbo.Sales(OrderID, CustomerID, OrderDate, TotalDue)
VALUES(1,1,GETDATE(),100);

--Add a CHECK CONSTRAINT
ALTER TABLE dbo.Sales 
ADD CONSTRAINT cn_Sales_TotalDueOver0 CHECK (TotalDue > 0);

--Try to add an order with a negative number
INSERT INTO dbo.Sales(OrderID, CustomerID, OrderDate, TotalDue)
VALUES(2,1,GETDATE(),-100);

--Updates 
--ALWAYS have a WHERE clause and test first!
--Don't develop on Production!
SELECT * 
FROM dbo.Customers
WHERE CustomerID = 2;

--Paste SELECT statement to make sure you get the same 
--WHERE clause
UPDATE dbo.Customers 
SET FirstName = 'Teresa'
--SELECT * 
FROM dbo.Customers
WHERE CustomerID = 2;

SELECT * 
FROM dbo.Customers
WHERE CustomerID = 2;

--Try to update the IDENTITY column
UPDATE dbo.Customers 
SET CustomerID = 100 
WHERE CustomerID = 1;

--Try to update a foreign key field to an invalid value
UPDATE dbo.Sales 
SET CustomerID = 100 
WHERE OrderID =1;

select * from dbo.Sales;

--Try to update with an invalid value 
UPDATE dbo.Sales 
SET TotalDue = -100
WHERE OrderID = 1;

--Update with a join 
--Write a SELECT first to find the row you are going to update
SELECT Cust.*
FROM dbo.Customers AS Cust 
INNER JOIN Sales ON Sales.CustomerID = Cust.CustomerID 
WHERE OrderID = 1;

--Copy the SELECT 
UPDATE Cust 
SET FirstName = 'Kenneth'
--SELECT Cust.*
FROM dbo.Customers AS CUST 
JOIN dbo.Sales ON Cust.CustomerID =Sales.CustomerID 
WHERE OrderID =1;

--You can use TOP with updates 
UPDATE TOP(5) dbo.Customers 
SET Active = 0;

SELECT * FROM dbo.Customers;

--Try to update with an aggregate
--Create a temp table 
SELECT CustomerID, 0 AS [Year], 0.00 AS TotalSales 
INTO #CustomerSales
FROM Sales.Customer;

UPDATE Cust 
SET [Year] = YEAR(OrderDate), 
	[TotalSales] = SUM(TotalDue) 
FROM #CustomerSales AS Cust 
INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.CustomerID = Cust.CustomerID
GROUP BY SOH.CustomerID, YEAR(OrderDate);

--You will learn how to do this in a future week!

--DELETES
--Always use a WHERE CLAUSE!!!!!!!

--Write a SELECT first
SELECT * FROM dbo.Customers 
WHERE CustomerID = 5;

--Paste it in and write the delete
DELETE FROM dbo.Customers
--SELECT * FROM dbo.Customers 
WHERE CustomerID = 5;

--Try to delete a customer with an order
DELETE dbo.Customers 
WHERE CustomerID =1 ;

--Change the foreign key by dropping 
--and recreating
ALTER TABLE dbo.Sales 
DROP CONSTRAINT [FK_Sales_Customers]

ALTER TABLE dbo.Sales  WITH CHECK ADD  CONSTRAINT 
	[FK_Sales_Customers] FOREIGN KEY([CustomerID])
REFERENCES dbo.Customers ([CustomerID])
ON DELETE CASCADE;

DELETE dbo.Customers 
WHERE CustomerID =1 ;

SELECT * FROM dbo.Sales;

--Can use TOP
DELETE TOP(5) 
FROM dbo.Customers;

--Can do in a join
INSERT INTO dbo.Sales(OrderID, CustomerID, OrderDate, TotalDue)
VALUES(10,10,GETDATE(),200);

DELETE Cust 
--SELECT Cust.*
FROM dbo.Customers AS Cust 
LEFT OUTER JOIN dbo.Sales ON Sales.CustomerID = Cust.CustomerID
WHERE OrderID IS NULL;







