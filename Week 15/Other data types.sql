--Special data types

--XML

SELECT CatalogDescription 
FROM Production.ProductModel
WHERE CatalogDescription IS NOT NULL;

SELECT ProductID, Name, Color, Size 
FROM Production.Product
FOR XML RAW;

SELECT ProductID, Name, Color, Size 
FROM Production.Product
FOR XML RAW ('Products'), Elements;

SELECT ProductID, Name, Color, Size 
FROM Production.Product
FOR XML AUTO; 

SELECT ProductID, Name, Color, Size 
FROM Production.Product
FOR XML PATH('Product');

--JSON
SELECT ProductID, Name, Color, Size 
FROM Production.Product 
FOR JSON PATH;


--Spatial
 


-- Listing 16-11. Using the GEOGRAPHY Data Type 
GO  
--1     
--select SpatialLocation.ToString(), * from person.Address
DECLARE @OneAddress GEOGRAPHY;        
--2   Save AddressID 91  
SELECT @OneAddress = SpatialLocation     
FROM Person.Address     
WHERE AddressID = 91;        
--3 How many meters away from AddressID 91    
SELECT AddressID,PostalCode, SpatialLocation.ToString(),         
	@OneAddress.STDistance(SpatialLocation) AS DiffInMeters     
FROM Person.Address    
WHERE AddressID IN (1,91, 831,11419); 



-- Listing 16-12. Viewing Spatial Results  
--1     
DECLARE @Area GEOMETRY;        
--2     
SET @Area = geometry::Parse('Polygon((1 4, 2 5, 5 2, 0 4, 1 4))');        
--3     
SELECT @Area AS Area;        
  
-- Listing 16-13. Example of Curved Lines Using CIRCULARSTRING and COMPOUNDCURVE  
DECLARE @g geometry;       
SET @g = geometry:: STGeomFromText('CIRCULARSTRING(1 2, 2 1, 4 3)', 0);     
SELECT @g.ToString();        
SET @g = geometry::STGeomFromText('     
	COMPOUNDCURVE(     
	CIRCULARSTRING(1 2, 2 1, 4 3),     
	CIRCULARSTRING(4 3, 3 4, 1 2))', 0);     
SELECT @g AS Area;    




-- Listing 16-14. Example of Mixing Straight and Curved Lines Using COMPOUNDCURVE  
GO 
DECLARE @g geometry = 'COMPOUNDCURVE(CIRCULARSTRING(2 0, 0 2, -2 0), (-2 0, 2 0))';     
SELECT @g;   
  




 





© 2018 GitHub, Inc.
Terms
Privacy
Security
Status
Help
