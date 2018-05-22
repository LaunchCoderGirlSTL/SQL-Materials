--Objects

--User Defined Scalar Functions
DROP FUNCTION IF EXISTS dbo.Add2Integers;
GO
CREATE FUNCTION dbo.Add2Integers(@a INT, @b INT)
RETURNS INT AS
BEGIN
	RETURN @a + @b;
END
GO

SELECT SalesOrderID, CustomerID, dbo.Add2Integers(SalesOrderID,CustomerID) AS Added 
FROM Sales.SalesOrderHeader;


GO
DROP FUNCTION IF EXISTS dbo.GetCustomerTotal;
GO
CREATE FUNCTION dbo.GetCustomerTotal(@CustomerID INT) 
RETURNS MONEY AS 
BEGIN
	DECLARE @Total MONEY
	SELECT @Total = SUM(TotalDue) 
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;

	RETURN @Total;
END
GO

SELECT dbo.GetCustomerTotal(11100);

--Not a good idea! Better to write an aggregate query
SELECT CustomerID, dbo.GetCustomerTotal(CustomerID) AS TotalSales
FROM Sales.Customer;


--Can also include loops and ifs
DROP FUNCTION IF EXISTS dbo.DelimString;
GO
CREATE FUNCTION dbo.DelimString(@string NVARCHAR(100),@delim NVARCHAR(1))
RETURNS NVARCHAR(200) AS 
BEGIN 
	DECLARE @NewString NVARCHAR(200) = '';
	DECLARE @count INT = 1;

	WHILE @count <= LEN(@string) BEGIN 
		SET @NewString = @NewString + SUBSTRING(@string,@count,1) + @delim;
		SET @count += 1;
	END
	RETURN @NewString;

END
GO

SELECT FirstName, dbo.DelimString(FirstName,'*') 
FROM Person.Person ;

--Inline table-valued functions, like "filtered views"
DROP FUNCTION IF EXISTS dbo.udfGetCustomerSales;
GO
CREATE FUNCTION dbo.udfGetCustomerSales(@CustomerID INT, @Year INT) 
RETURNS TABLE 
AS RETURN (

	SELECT soh.SalesOrderID, soh.OrderDate, soh.ShipDate, soh.Status, soh.SalesOrderNumber, soh.PurchaseOrderNumber,
		sod.SalesOrderDetailID, sod.ProductID, sod.OrderQty, sod.UnitPrice, sod.LineTotal, soh.CustomerID,
		p.Name AS ProductName, c.AccountNumber AS CustomerAccountNumber
	FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
	INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
	INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	WHERE c.CustomerID = @CustomerID AND YEAR(OrderDate) = @Year
)
GO

SELECT Cust.CustomerID, Sales.OrderDate, Sales.LineTotal, Sales.ProductID, Sales.ProductName
FROM Sales.Customer AS Cust 
CROSS APPLY dbo.udfGetCustomerSales(CustomerID,2011) AS Sales;

GO
--Multi-statement table valued function -- BAD NEWS!
DROP FUNCTION IF EXISTS dbo.udfMLGetCustomerTotal;
GO
CREATE FUNCTION dbo.udfMLGetCustomerTotal (@CustomerID INT, @Year INT)
RETURNS 
@Table TABLE 
(
	CustomerID INT, TotalSales MONEY	
)
AS
BEGIN
	--Check to see if there were sales that year
	IF EXISTS(SELECT * FROM Sales.SalesOrderHeader WHERE CustomerID = @CustomerID) BEGIN
		INSERT INTO @Table(CustomerID, TotalSales)
		SELECT CustomerID, SUM(TotalDue) 
		FROM Sales.SalesOrderHeader
		WHERE CustomerID = @CustomerID
			AND YEAR(OrderDate) = @Year
		GROUP BY CustomerID
	END 
	ELSE BEGIN
		INSERT INTO @Table(CustomerID, TotalSales)
		VALUES(@CustomerID, -1)
	END
	RETURN;
END;
GO

SELECT Cust.CustomerID, Sales.TotalSales
FROM Sales.Customer AS Cust 
CROSS APPLY dbo.udfMLGetCustomerTotal(CustomerID, 2011) AS Sales;
	
--User Defined types
--From AdventureWorks
GO
--CREATE TYPE [dbo].[Name] FROM [nvarchar](50) NULL
GO
DROP TABLE IF EXISTS dbo.Names
GO
CREATE TABLE Names(FirstName NAME, LastName NAME);
GO
INSERT INTO Names(FirstName, LastName)
SELECT FirstName, LastName 
FROM Person.person;

SELECT * FROM Names;






	




