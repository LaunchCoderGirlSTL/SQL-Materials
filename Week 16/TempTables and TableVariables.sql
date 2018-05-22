--Temp tables and table variables
DROP TABLE IF EXISTS #CustomerSales;
GO
CREATE TABLE #CustomerSales(
	CustomerID INT, 
	TotalSales DECIMAL(18,2));
GO
INSERT INTO #CustomerSales(CustomerID, TotalSales)
SELECT CustomerID, SUM(TotalDue)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

SELECT * FROM #CustomerSales;

DROP TABLE #CustomerSales;

GO

DROP TABLE IF EXISTS ##CustomerSales;
GO
CREATE TABLE ##CustomerSales(
	CustomerID INT, 
	TotalSales DECIMAL(18,2));
GO
INSERT INTO ##CustomerSales(CustomerID, TotalSales)
SELECT CustomerID, SUM(TotalDue)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

SELECT * FROM ##CustomerSales;	

SELECT CustomerID, SUM(TotalDue) TotalSales
INTO #CustomerSales
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

--Table Variables
DECLARE @CustomerSales TABLE(CustomerID INT, TotalSales DECIMAL(18,2));
INSERT INTO @CustomerSales(CustomerID, TotalSales)
SELECT CustomerID, SUM(TotalDue)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;;

SELECT * FROM @CustomerSales;
