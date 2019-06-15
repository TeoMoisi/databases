CREATE DATABASE S6
GO
USE S6
GO

-- a) create the tables
CREATE TABLE Stations (
    Sid int PRIMARY KEY IDENTITY,
    SName VARCHAR(50)
)
  
CREATE TABLE TrainTypes (
    TypeID INT PRIMARY KEY IDENTITY,
    Descr VARCHAR(60)
)

CREATE TABLE Trains (
    Tid int PRIMARY key IDENTITY,
    TName VARCHAR(60),
    TypeID INT FOREIGN KEY REFERENCES TrainTypes(TypeID) ON DELETE CASCADE
)

CREATE TABLE Routes (
    Rid INT PRIMARY KEY IDENTITY,
    RName VARCHAR(60),
    Tid INT FOREIGN KEY REFERENCES Trains(Tid) ON DELETE CASCADE
)

CREATE TABLE RouteStations (
    Rid INT FOREIGN KEY REFERENCES Routes(Rid),
    Sid INT FOREIGN KEY REFERENCES Stations(Sid),
    ArrivalTime TIME,
    Departure TIME,
    CONSTRAINT pk_RouteStations PRIMARY KEY (Rid, Sid)
)

-- b) create a procedure that adds in RouteStations

GO
CREATE PROCEDURE INSERT_RS @Rid INT, @Sid INT, @ArrTime TIME, @DepTime TIME
AS
    DECLARE @no INT
    SET @no = 0
    SELECT @no = COUNT(*) FROM RouteStations WHERE Rid = @Rid AND Sid = @Sid
    IF @no <> 0
        BEGIN
            PRINT 'Already inserted'
        END
    ELSE
        BEGIN
            INSERT INTO RouteStations VALUES (@Rid, @Sid, @ArrTime, @DepTime)
        END
END


EXEC INSERT_RS 2, 1,'15:00:00', '19:00:00'

GO

-- c) 

CREATE VIEW vRS
AS
    SELECT RName
    FROM Routes R INNER JOIN RouteStations RS
        ON R.Rid = RS.Rid
    GROUP BY R.Rid, R.RName
    HAVING COUNT(*) = (SELECT 
    COUNT(*) FROM Stations)
GO

SELECT * FROM vRS

-- d)
GO
 CREATE FUNCTION fctSR(@n INT)
 RETURNS TABLE 
 AS
    RETURN 
        SELECT DISTINCT SName, COUNT(SName) AS noOfRoots
        FROM Stations S INNER JOIN RouteStations RS
            ON S.Sid = RS.Sid
        GROUP BY SName HAVING COUNT(SName) >= @n
GO

SELECT * FROM fctRS(5)
