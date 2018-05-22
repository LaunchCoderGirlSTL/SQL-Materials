
USE LearnSQL
GO

CREATE TABLE t1 (
	INT1 INT,
	DEC1 DECIMAL(5,1),
	DATE1 DATETIME,
)

SELECT * FROM T1

INSERT INTO t1 --(INT1, DEC1, DATE1)
VALUES (1, 2.5, '1/1/2017')

INSERT INTO t1 (INT1, DEC1, DATE1)
SELECT 2, 5.2, '2/1/2017'


INSERT INTO t1 (INT1, DEC1, DATE1)
VALUES 
	(3, 6.5, '3/1/2017'), 
	(4, 3.3, '4/1/2017'),
	(5, 7.7, '5/1/2017')

INSERT INTO t1
SELECT 6, 6.2, GETDATE()
UNION ALL
SELECT 7, 7.2, GETDATE()
UNION ALL
SELECT 8, 8.2, GETDATE() 

INSERT INTO t1(INT1, DEC1, DATE1)
SELECT VeterinarianVisitIdentifier, 
	CAST(DogIdentifier/3.0 AS decimal(5,1)),
	DateOfNextAppointment
 FROM VeterinarianVisitHistory;


SELECT * FROM t1

-- DROP TABLE t1



CREATE TABLE t2 (
	ID INT IDENTITY(1,1),
	INT1 INT NULL,
	INT2 INT NOT NULL,
	STR1 VARCHAR(30) NULL,
	STR2 NVARCHAR(30) NULL
)

INSERT INTO t2 (INT1, INT2, STR1, STR2)
VALUES (100, 200, 'This is Str1', 'This is Str2'),
	   (200, 300, 'This is Str1', 'This is Str2')	

SELECT * 
FROM t2

INSERT INTO t2 (INT1, STR1)
VALUES (300, 'This is Str1 again')

INSERT INTO t2 (INT2)
VALUES (300)

SELECT * 
FROM t2


SELECT VeterinarianVisitIdentifier, 
	DogIdentifier/3.0 AS DogIDent,
	DateOfNextAppointment
INTO t3
 FROM VeterinarianVisitHistory;

SELECT * FROM t3;

DROP Table t2
DROP Table t3
















