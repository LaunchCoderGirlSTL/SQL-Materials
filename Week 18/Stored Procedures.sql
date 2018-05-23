--Stored procedures!

--T-SQL programming logic
--IF
DECLARE @Char1 CHAR(1) = 'A';
DECLARE @Char2 CHAR(1) = 'A';

IF @Char1 = @Char2 PRINT @Char1 + ' = ' + @Char2;
GO



--Add an ELSE
DECLARE @Char1 CHAR(1) = 'A';
DECLARE @Char2 CHAR(1) = 'B';

IF @Char1 = @Char2 PRINT @Char1 + ' = ' + @Char2
ELSE PRINT @Char1 + ' <> ' + @Char2;
GO

--Runs next line
DECLARE @Char1 CHAR(1) = 'A';
DECLARE @Char2 CHAR(1) = 'B';
IF @Char1 <> @Char2 
	PRINT @Char1 + ' <> ' + @Char2;
ELSE 
	PRINT @Char1 + ' = ' + @Char2;
	PRINT 'This should run with ELSE, but it runs anyway';
GO

--More complex blocks
DECLARE @Char1 CHAR(1) = 'A';
DECLARE @Char2 CHAR(1) = 'B';
IF @Char1 <> @Char2 BEGIN
	PRINT @Char1 + ' <> ' + @Char2;
END
ELSE BEGIN
	PRINT @Char1 + ' = ' + @Char2;
	PRINT 'This should run with ELSE';
END;

GO


--Nesting
DECLARE @Char1 CHAR(1) = 'B';
DECLARE @Char2 CHAR(1) = 'A';
IF @Char1 = @Char2 BEGIN
	PRINT @Char1 + ' = ' + @Char2;
END
ELSE BEGIN
	IF @Char1 > @Char2 PRINT @Char1 + ' > ' + @Char2;
	ELSE PRINT @Char1 + ' < ' + @Char2;
END; 


--Looping
DECLARE @Count INT = 0;
WHILE @Count < 100 BEGIN 
	PRINT @Count;
	SET @Count += 1; --increment the count
END;
GO

--Use a temp table to control the loop
USE AdventureWorks2014;
GO
SELECT TOP(10) CustomerID 
INTO #Customers
FROM Sales.Customer;

DECLARE @CustomerID INT;
WHILE EXISTS(SELECT * FROM #Customers) BEGIN 
	SELECT @CustomerID = CustomerID 
	FROM #Customers;
	PRINT 'Deleting ' + CAST(@CustomerID AS VARCHAR(10));
	DELETE FROM #Customers
	WHERE CustomerID = @CustomerID;
END;
GO

--Nesting
DECLARE @i INT = 1;
DECLARE @j INT = 1;

WHILE @i < 10 BEGIN 
	SET @j = 1;
	WHILE @j < 10 BEGIN 
		PRINT CONCAT('@i = ',@i, ', @j= ',@j,', @i * @j = ',@i * @j); 
		SET @j = @j + 1;
	END
	SET @i += 1; --two ways to increment
END;
GO

--Combine with IF
DECLARE @i INT = 1;
DECLARE @j INT = 1;

WHILE @i < 10 BEGIN 
	SET @j = 1;
	WHILE @j < 10 BEGIN 
		IF @i = @j PRINT '@i = @j';
		ELSE BEGIN 
			IF @i > @j PRINT '@i > @j'
			ELSE PRINT '@i < @j';
		END;
		PRINT CONCAT('@i = ',@i, ', @j= ',@j,', @i * @j = ',@i * @j); 
		SET @j = @j + 1;
	END
	SET @i += 1; --two ways to increment
END;


--Stored procedures
GO
--Tables for example
DROP TABLE IF EXISTS dbo.Product;
DROP TABLE IF EXISTS dbo.Category;
GO
CREATE TABLE dbo.Category(
	CategoryID INT NOT NULL IDENTITY PRIMARY KEY,
	CategoryName NVARCHAR(25) NOT NULL);

CREATE TABLE dbo.Product(
	ProductID INT NOT NULL IDENTITY PRIMARY KEY,
	ProductName NVARCHAR(25),
	ListPrice DECIMAL(5,2),
	CategoryID INT NOT NULL FOREIGN KEY REFERENCES dbo.Category(CategoryID));
	

GO
--A proc to insert data
GO
DROP PROC IF EXISTS dbo.InsertProduct;
GO
/*
PROC: usp_InsertProduct
AUTHOR: <add your name>
DATE CREATED: <the date>
PURPOSE: Tell what the proc does
PARAMETERS: Explain the parameters
NOTES:
UPDATES: 
*/
CREATE PROC dbo.InsertProduct 
	@ProductName NVARCHAR(25), 
	@CategoryName NVARCHAR(25),
	@ListPrice DECIMAL(5,2) AS 

	--List variables that will be needed 
	DECLARE @CategoryID INT --Look up the categoryID

	--Find the category ID
	SELECT @CategoryID = CategoryID 
	FROM dbo.Category 
	WHERE CategoryName = @CategoryName;

	IF @CategoryID IS NULL BEGIN 
		--need to add the new category
		INSERT INTO dbo.Category(CategoryName)
		VALUES(@CategoryName);

		--save the new ID value
		SET @CategoryID = SCOPE_IDENTITY();
	END;

	IF EXISTS(SELECT * FROM dbo.Product WHERE ProductName = @ProductName) BEGIN 
		RETURN 1; -- the item already exists!
	END
	BEGIN 
		INSERT INTO dbo.Product(ProductName, CategoryID, ListPrice)
		VALUES(@ProductName, @CategoryID, @ListPrice);
		RETURN 0; -- success!
	END;
GO
--Try it out!
DECLARE @ReturnValue INT;
EXEC @ReturnValue = dbo.InsertProduct @ProductName = 'Red tricycle', @CategoryName = 'Bikes', @ListPrice = 30;
PRINT @ReturnValue;

SELECT * FROM dbo.Product;
SELECT * FROM dbo.Category;

GO
--Category already exists
DECLARE @ReturnValue INT;
EXEC @ReturnValue = dbo.InsertProduct @ProductName = 'Blue tricycle', @CategoryName = 'Bikes', @ListPrice = 30;
PRINT @ReturnValue;

SELECT * FROM dbo.Product;
SELECT * FROM dbo.Category;

--Try to insert a duplicate
GO
DECLARE @ReturnValue INT;
EXEC @ReturnValue = dbo.InsertProduct @ProductName = 'Blue tricycle', @CategoryName = 'Bikes', @ListPrice = 30;
PRINT @ReturnValue;

SELECT * FROM dbo.Product;
SELECT * FROM dbo.Category;

GO
--Updates, either make the insert flexible or create a separate update proc
/*
PROC: usp_InsertProduct
AUTHOR: <add your name>
DATE CREATED: <the date>
PURPOSE: Tell what the proc does
PARAMETERS: Explain the parameters
NOTES:
UPDATES: 
*/
ALTER PROC dbo.InsertProduct 
	@ProductName NVARCHAR(25), 
	@CategoryName NVARCHAR(25),
	@ListPrice DECIMAL(5,2) AS 

	--List variables that will be needed 
	DECLARE @CategoryID INT 

	--Find the category ID
	SELECT @CategoryID = CategoryID 
	FROM dbo.Category 
	WHERE CategoryName = @CategoryName;

	IF @CategoryID IS NULL BEGIN 
		--need to add the new category
		INSERT INTO dbo.Category(CategoryName)
		VALUES(@CategoryName);

		--save the new ID value
		SET @CategoryID = SCOPE_IDENTITY();
	END;

	IF EXISTS(SELECT * FROM dbo.Product WHERE ProductName = @ProductName) BEGIN 
		--Add an update statement
		UPDATE dbo.Product 
		SET CategoryID = @CategoryID, 
			ListPrice = @ListPrice
		WHERE ProductName = @ProductName;
		RETURN 1; -- the item already exists!
	END
	BEGIN 
		INSERT INTO dbo.Product(ProductName, CategoryID, ListPrice)
		VALUES(@ProductName, @CategoryID, @ListPrice);
		RETURN 0; -- success!
	END;
GO

DECLARE @ReturnValue INT;

EXEC @ReturnValue = dbo.InsertProduct  @ProductName = 'Blue Tricycle', @CategoryName = 'Trikes',@ListPrice = 35;
PRINT @ReturnValue;

SELECT * FROM dbo.Product;
SELECT * FROM dbo.Category;

--Default values
GO
DROP PROC IF EXISTS dbo.usp_GetProductList;
GO
--Return all product categories if @CategoryID not supplied
CREATE PROC dbo.usp_GetProductList @CategoryID INT = NULL AS 
	SELECT Prod.ProductID, Prod.ProductName, Cat.CategoryName, Prod.ListPrice
	FROM dbo.Product AS Prod 
	INNER JOIN dbo.Category AS Cat ON Prod.CategoryID = Cat.CategoryID
	WHERE (@CategoryID IS NULL OR Cat.CategoryID = @CategoryID);
;

EXEC dbo.usp_GetProductList ;

EXEC dbo.usp_GetProductList @CategoryID = 1;

--Deletion proc
GO
DROP PROC IF EXISTS dbo.usp_DeleteProduct;
GO
CREATE PROC dbo.usp_DeleteProduct @ProductID INT AS 

	DELETE FROM dbo.Product WHERE ProductID = @ProductID;

GO

EXEC dbo.usp_DeleteProduct @ProductID = 1;

SELECT * FROM dbo.Product;

GO

--Populate a table
EXEC dbo.usp_GetProductList;

CREATE TABLE #Products (ProductID INT, 
	ProductName NVARCHAR(25),
	CategoryName NVARCHAR(25),
	ListPrice DECIMAL(5,2)
	);

INSERT INTO #Products(ProductID, ProductName, CategoryName, ListPrice)
EXEC dbo.usp_GetProductList;

SELECT * FROM #Products;

  










	