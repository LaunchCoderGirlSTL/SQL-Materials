
USE AdventureWorks2014
GO


CREATE VIEW vwSalesOrderHeaderDetail AS

	SELECT soh.SalesOrderID, soh.OrderDate, soh.ShipDate, soh.Status, soh.SalesOrderNumber, soh.PurchaseOrderNumber,
		sod.SalesOrderDetailID, sod.ProductID, sod.OrderQty, sod.UnitPrice, sod.LineTotal, soh.CustomerID,
		p.Name AS ProductName, c.AccountNumber AS CustomerAccountNumber
	FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
	INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
	INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID




select * from vwSalesOrderHeaderDetail

select * from vwSalesOrderHeaderDetail where ProductName like 'Long%Sleeve%'

select ProductName, c.AccountNumber, count(*) 
from vwSalesOrderHeaderDetail v
INNER JOIN sales.Customer c on v.CustomerID = c.customerID
Group by ProductName, c.AccountNumber











