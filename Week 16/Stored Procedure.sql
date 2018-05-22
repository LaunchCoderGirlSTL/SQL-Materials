--Stored Procedures
USE MASTER; 
GO
CREATE PROC usp_CreateADB AS 
	CREATE DATABASE TESTING
GO
EXEC usp_CreateADB;

USE [AdventureWorks2014]
GO
DROP PROC IF EXISTS dbo.usp_GetCustomers;
GO

CREATE PROC [dbo].[usp_GetCustomers] AS 
	SELECT Cust.CustomerID, FirstName, LastName, Store.Name AS StoreName
	FROM Sales.Customer AS Cust
	INNER JOIN Person.Person AS Pers ON Cust.CustomerID = Pers.BusinessEntityID 
	LEFT JOIN Sales.Store AS Store on Store.BusinessEntityID = Cust.StoreID;

GO

EXEC dbo.usp_GetCustomers;


GO
DROP PROCEDURE IF EXISTS dbo.usp_GetCustomerInfo;
GO
CREATE PROC [dbo].[usp_GetCustomerInfo] @CustomerID INT AS 
	SELECT Cust.CustomerID, FirstName, LastName, Store.Name AS StoreName
	FROM Sales.Customer AS Cust
	INNER JOIN Person.Person AS Pers ON Cust.CustomerID = Pers.BusinessEntityID 
	LEFT JOIN Sales.Store AS Store on Store.BusinessEntityID = Cust.StoreID
	WHERE Cust.CustomerID = @CustomerID;

GO
DECLARE @CustomerID INT = 11000;
EXEC dbo.usp_GetCustomerInfo @CustomerID = @CustomerID;
EXEC dbo.usp_GetCustomerInfo 285;

GO
DROP PROC IF EXISTS dbo.usp_GetCustomerSalesForYear;
GO
--Default value
CREATE PROC [dbo].[usp_GetCustomerSalesForYear] @CustomerID INT, @Year INT = 2011 AS 
	SELECT Cust.CustomerID, ISNULL(Store.Name,Pers.FirstName + ' ' + Pers.LastName) AS CustomerName,
		 SUM(TotalDue) AS TotalSales
	FROM Sales.SalesOrderHeader SOH 
	INNER JOIN Sales.Customer AS Cust ON SOH.CustomerID = Cust.CustomerID
	LEFT OUTER JOIN Person.Person AS Pers ON Cust.CustomerID = Pers.BusinessEntityID 
	LEFT OUTER JOIN Sales.Store AS Store ON Cust.StoreID = Store.BusinessEntityID
	WHERE YEAR(OrderDate) = @Year AND Cust.CustomerID = @CustomerID
	GROUP BY  Cust.CustomerID, ISNULL(Store.Name,Pers.FirstName + ' ' + Pers.LastName);
GO
EXEC usp_GetCustomerSalesForYear @CustomerID = 29825;
EXEC usp_GetCustomerSalesForYear @CustomerID = 29825, @Year = 2012;

GO


