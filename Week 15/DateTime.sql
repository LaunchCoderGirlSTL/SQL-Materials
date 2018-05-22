DROP TABLE IF EXISTS DateDemo;
GO
CREATE TABLE DateDemo (
	JustTheDate DATE, 
	JustTheTime TIME,
	TimeNoDecimal TIME(0),
	NewDateTime2 DATETIME2(3),
	UTCDateAndTime DATETIME2);

--Also DATETIME, SMALLDATETIME, DATETIMEOFFSET

INSERT INTO DateDemo(JustTheDate, JustTheTime,TimeNoDecimal, NewDateTime2, UTCDateAndTime)
SELECT GETDATE(), GETDATE(), GETDATE(), SYSDATETIME(), SYSUTCDATETIME();

SELECT * FROM DateDemo;

SELECT SalesOrderID, CAST(OrderDate AS DATE)
FROM Sales.SalesOrderHeader;


