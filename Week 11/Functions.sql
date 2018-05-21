Use AdventureWorks2014;
GO
--Start functions and expressions

--Anything that evaluates to a value is an expression
SELECT 1;
Print 1;

SELECT FirstName, LastName, 
	FirstName +  ' ' + LastName AS FullName,
	CONCAT(FirstName, ' ',LastName) AS fullName2
FROM Person.person;

SELECT FirstName, LastName, Middlename, 
	FirstName + ' ' + Middlename + ' ' +  LastName AS FullName,
	CONCAT(FirstName, ' '+ MiddleName, ' ',LastName) AS fullName2
FROM Person.person;

SELECT FirstName, LastName, Middlename, 
	FirstName + ' ' + Middlename + ' ' +  LastName AS FullName,
	CONCAT(FirstName, ' '+ MiddleName, ' ',LastName) AS fullName2,
	LastName + CAST(BusinessEntityID AS nvarchar(10)),
	LastName + CONVERT(nvarchar(10),BusinessEntityID),
	CONCAT(Lastname,BusinessEntityID)
FROM Person.person;

select getdate() as TheDateAndTime,convert(varchar(20),getdate(),101) TheDate







SELECT SalesOrderID, SalesOrderID/2 DivideBy2
FROM Sales.SalesOrderHeader;

--Functions
SELECT GETDATE();

--Find the a
SELECT CHARINDEX('a',FirstName), FirstName
FROM person.person;

--Return the last 5 characters
SELECT RIGHT(FirstName,5), FirstName
FROM Person.Person;

--Reverse the order 
SELECT REVERSE(FirstName), FirstName
FROM Person.Person;

DECLARE @String varchar(30) = 'C:\temp\abc\def\gef\file.txt'
SELECT @String

--Find the file name
SELECT REVERSE(@String)

--Find the first \
SELECT CHARINDEX('\',REVERSE(@string))

--Display the last 8 characters
SELECT RIGHT(@string,CHARINDEX('\',REVERSE(@String))-1)
--End Expressions and functions


--Start aggregate query
--Using COUNT

select count(*) AS [RowCount]
from production.product;

SELECT COUNT_BIG(*) AS CountOfRows,        
	COUNT(Color) AS CountOfColor,            
	COUNT(DISTINCT Color) AS CountOfDistinctColor    
FROM Production.Product;  

select count(isnull(size,'')) 
from Production.Product;

--Other functions
SELECT COUNT(*) AS CountOfRows,
	MAX(ListPrice) AS HighestPrice,
	MIN(Name) AS MinName,
	AVG(ListPrice) AS AverageListPrice,
	STDEV(ListPrice) AS StandardDeviationListPrice
FROM Production.Product;

--GROUPING
--Add a non-aggregated column causes an error
SELECT Color,
	COUNT(*) AS CountOfRows,
	MAX(ListPrice) AS HighestPrice,
	MIN(Name) AS MinName,
	AVG(ListPrice) AS AverageListPrice
FROM Production.Product;

--Add the column to the GROUP BY clause
SELECT Color,
	COUNT(*) AS CountOfRows,
	MAX(ListPrice) AS HighestPrice,
	MIN(Name) AS MinName,
	AVG(ListPrice) AS AverageListPrice
FROM Production.Product
GROUP BY Color
;


--grouping on an expression
SELECT COUNT(*) AS CountOfOrders, YEAR(OrderDate) AS OrderYear    
FROM Sales.SalesOrderHeader;   
  


 --One row per orderdate
 --Not correct!!
SELECT COUNT(*) AS CountOfOrders, YEAR(OrderDate) AS OrderYear 
FROM Sales.SalesOrderHeader    
GROUP BY OrderDate;       
 
-- One row per order year   
SELECT COUNT(*) AS CountOfOrders, YEAR(OrderDate) AS OrderYear    
FROM Sales.SalesOrderHeader 
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear; 


--Number of rows returned is the number of unique groupings
SELECT SUM(TotalDue) AS total, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth
FROM Sales.SalesOrderHeader 
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate);

--END Aggregate Queries


--Filtering aggregates
--Using the WHERE Clause       
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer    
FROM Sales.SalesOrderHeader    
WHERE TerritoryID in (5,6)    
GROUP BY CustomerID; 

--This doesn't work
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer    
FROM Sales.SalesOrderHeader    
WHERE TerritoryID in (5,6) 
	AND SUM(TotalDue) > 5000   
GROUP BY CustomerID; 

--Using the HAVING Clause    
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer    
FROM Sales.SalesOrderHeader   
WHERE TerritoryID in (5,6)  
GROUP BY CustomerID    
HAVING SUM(TotalDue) > 5000;  

select * from sales.SalesTerritory     
   
--Aggregate expression doesn't need to display in SELECT
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer    
FROM Sales.SalesOrderHeader    
GROUP BY CustomerID    
HAVING COUNT(*) = 10 AND SUM(TotalDue) > 5000;       
   
--Works, but SQL Server moves the expression to the WHERE clause 
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer    
FROM Sales.SalesOrderHeader    
GROUP BY CustomerID    
HAVING CustomerID > 27858;   


--Writing Aggregate Queries with Two Tables    

SELECT c.CustomerID, c.AccountNumber, COUNT(*) AS CountOfOrders,        
	SUM(TotalDue) AS SumOfTotalDue    
FROM Sales.Customer AS c    
INNER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID    
GROUP BY c.CustomerID, c.AccountNumber    
ORDER BY c.CustomerID;  
     
--SOME NULLs   
SELECT c.CustomerID, c.AccountNumber, COUNT(*) AS CountOfOrders,        
	SUM(TotalDue) AS SumOfTotalDue       
FROM Sales.Customer AS c    
	LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID    
GROUP BY c.CustomerID, c.AccountNumber    
ORDER BY c.CustomerID;       
--Change NULLs to 0  
SELECT c.CustomerID, c.AccountNumber,COUNT(s.SalesOrderID) AS CountOfOrders,        
	SUM(COALESCE(TotalDue,0)) AS SumOfTotalDue    
FROM Sales.Customer AS c    
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID    
GROUP BY c.CustomerID, c.AccountNumber    
ORDER BY c.CustomerID; 
--End filtering aggregates



   


   