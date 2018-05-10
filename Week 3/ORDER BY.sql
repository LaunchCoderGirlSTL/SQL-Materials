--Week 4 ORDER BY
USE AdventureWorks2014;
GO

SELECT LastName, FirstName 
FROM Person.Person; 

SELECT LastName, FirstName 
FROM Person.Person 
ORDER BY FirstName, LastName;

SELECT LastName, FirstName 
FROM Person.Person 
ORDER BY FirstName DESC, LastName;

SELECT LastName, FirstName 
FROM Person.Person 
ORDER BY FirstName DESC, LastName DESC;

SELECT LastName AS [Last Name], FirstName AS [First Name]
FROM Person.Person 
ORDER BY [First Name];

SELECT LastName AS [Last Name], FirstName AS [First Name]
FROM Person.Person 
ORDER BY 2;


SELECT LastName AS [Last Name], FirstName AS [First Name]
FROM Person.Person 
WHERE LastName = 'Smith'
ORDER BY 2;



