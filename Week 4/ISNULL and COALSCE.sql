USE AdventureWorks2014;
GO

SELECT ProductID, Name, Color, Size, Style 
FROM Production.Product
WHERE ListPrice > 0;

--Nulls cancel everything out
SELECT ProductID, Name, Color, Size, Style,
	Color + '-' + Size + '-' + Style AS Description  
FROM Production.Product
WHERE ListPrice > 0;

--Can use ISNULL to replace a null value
--Nulls cancel everything out
SELECT ProductID, Name, Color, Size, Style,
	ISNULL(Color,'N/A') + '-' + 
	ISNULL(Size,'N/A') + '-' + ISNULL(Style,'N/A') AS Description  
FROM Production.Product
WHERE ListPrice > 0;

--Use the COALSCE function to display the first non-NULL
SELECT ProductID, Name, Color, Size, Style,
	COALESCE(Color,'N/A') + '-' + 
	COALESCE(Size,'N/A') + '-' + COALESCE(Style,'N/A') AS Description  
FROM Production.Product
WHERE ListPrice > 0;

--Find the first non-Null in the list
SELECT ProductID, Name, Style,Size,Color,
	COALESCE(Style,Size,Color) AS Description  
FROM Production.Product
WHERE ListPrice > 0;