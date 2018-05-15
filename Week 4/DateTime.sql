CREATE TABLE #Time (ID INT IDENTITY, [DateTime] datetime2)

INSERT INTO #Time([DateTime])
VALUES('1/1/2018 00:00:00'),('12/31/2017 23:59:23'),('12/3/2017 0:00:00')

SELECT * FROM #Time ORDER BY DateTIme;

SELECT * FROM #time 
WHERE [DateTime] >= '12/1/2017' AND [DateTime] < '1/1/2018'
