-- 1. You must create a database that manages cinematics from different games. The purpose of the database is to
-- contain all the information about the cinematics of all games and some details about the heroes that appear in cinematics.
-- 	A) The entities of interest for the problem domani are: Heroes, Cinematics, Games and Companies.
-- 	B) Each game has a name, a release date and belongs to a company. The company has a name, a description and a website.
-- 	C) Each cinematic has a name, an associated game and a list of heroes with an entry moment for each hero.
-- 	The entry moment is represented as an hour/minute/second pair (ex: a hero appears at 00:02:33). Every hero
-- 	has a name, a description and an importance.

-- 1) Write a SQL script to create a relational data model in order to represent the required data. (4 points)

-- 2) Create a store procedure that receives a hero, a cinematic, and an entry moment and adds the new cinematic to
-- the hero. If the cinematic already exists, the entry moment is updated. (2 points)

-- 3) Create a view that shows the name and the importance of all heroes that appear in all cinematics. (1 point)

-- 4) Create a function that lists the name of the company, the name of the game and the title of the cinematic for all 
-- games that have the release date greater than or equal to '2000-12-02' and less than or equal to '2016-01-01'. (2 points)

CREATE DATABASE CGames
GO
USE CGames
GO

DROP TABLE Companies
DROP TABLE Games
DROP TABLE Cinematics
DROP TABLE Heroes
DROP TABLE HeroList
go

CREATE TABLE Companies (
    CompID int PRIMARY KEY IDENTITY(1,1),
    CompName VARCHAR(30),
    CompDescr VARCHAR(30),
    Website VARCHAR(30)
)

CREATE TABLE Games (
    GID int PRIMARY KEY IDENTITY(1,1),
    Gname VARCHAR(30),
    Release DATE,
    CompID int REFERENCES Companies(CompID)
)

CREATE TABLE Cinematics (
    CID INT  PRIMARY KEY IDENTITY(1,1),
    CName VARCHAR(50),
    GID int REFERENCES Games(GID)
)

CREATE TABLE Heroes (
    HID INT PRIMARY KEY IDENTITY(1,1),
    HName VARCHAR(30),
    HDescr VARCHAR(30),
    Himportance VARCHAR(30)
)

CREATE TABLE HeroList (
    HID INT REFERENCES Heroes(HID),
    CID INT REFERENCES Cinematics(CID),
    PRIMARY KEY(HID, CID),
    EntryMoment time
)

INSERT INTO Companies([CompName], [CompDescr], [Website]) VALUES ('GameLoft', 'gaming', 'www.gameloft.com')
select * from Companies

INSERT INTO Games([Gname],[Release], [CompID]) VALUES ('LOL', '2000-12-01', 1)
SELECT * FROM Games

INSERT INTO Cinematics([CName], [CID]) VALUES ('CINEMATIC', 1)
SELECT * FROM Cinematics

INSERT INTO Heroes([HName], [HDescr], [Himportance]) VALUES ('SuperWoman', 'dances', 11)
SELECT * from Heroes
SELECT * FROM HeroList

ins

-- 2) Create a store procedure that receives a hero, a cinematic, and an entry moment and adds the new cinematic to
-- the hero. If the cinematic already exists, the entry moment is updated. (2 points)
go
CREATE OR ALTER PROC InsCinToHero(@HeroName VARCHAR(30), @Hdescr VARCHAR(30), @Himp VARCHAR(30), @Cname VARCHAR(30), @CinGameID INT, @entrymom time)
AS
    DECLARE @existGameID int = (select Games.GID from Games where Games.GID = @CinGameID)
    if @existGameID is null
    BEGIN
        print 'The game does not exist'
        RETURN 1
    END

    DECLARE @existCinematic int = (select Cinematics.CID from Cinematics where Cinematics.GID = @CinGameID AND Cinematics.CName = @Cname)
    DECLARE @existHero int
    DECLARE @getHeroId INT
    DECLARE @getCinId int

    if @existCinematic is NULL
    BEGIN
        INSERT into Cinematics VALUES (@Cname, @CinGameID)
        set @existHero = (select Heroes.HID FROM Heroes where Heroes.HName = @HeroName AND Heroes.HDescr = @Hdescr AND Heroes.Himportance = @Himp)

        IF @existHero IS NULL
        BEGIN
            INSERT into Heroes VALUES (@HeroName, @Hdescr, @Himp)
            print 'hero inserted'
        END

        ELSE
            print 'hero exists'

        set @getHeroId = (select Heroes.HID FROM Heroes where Heroes.HName = @HeroName AND Heroes.HDescr = @Hdescr AND Heroes.Himportance = @Himp)
        SET @getCinId = (select Cinematics.CID from Cinematics where Cinematics.GID = @CinGameID AND Cinematics.CName = @Cname)

        INSERT INTO HeroList VALUES (@getHeroId, @getCinId, @entrymom)
    END

    if @existCinematic is NOT NULL
    BEGIN
        set @existHero = (select Heroes.HID FROM Heroes where Heroes.HName = @HeroName AND Heroes.HDescr = @Hdescr AND Heroes.Himportance = @Himp)

        IF @existHero IS NULL
        BEGIN
            INSERT into Heroes VALUES (@HeroName, @Hdescr, @Himp)
            print 'hero inserted'
        END

        ELSE
            print 'hero exists'

        set @getHeroId = (select Heroes.HID FROM Heroes where Heroes.HName = @HeroName AND Heroes.HDescr = @Hdescr AND Heroes.Himportance = @Himp)
        SET @getCinId = (select Cinematics.CID from Cinematics where Cinematics.GID = @CinGameID AND Cinematics.CName = @Cname)

        UPDATE HeroList
        set EntryMoment = @entrymom 
        where HeroList.HID = @getHeroId and HeroList.CID = @getCinId
    END
go

exec InsCinToHero 'SuperMan', 'flies', 10, 'CINEMATIC', 1, '10:00'

-- 3) Create a view that shows the name and the importance of all heroes that appear in all cinematics. (1 point)
go
CREATE or ALTER VIEW NameImportance
AS
    SELECT H.HName, H.Himportance from Heroes as H
    INNER JOIN HeroList as HL on H.HID = HL.HID
    GROUP BY H.HName, H.Himportance
    HAVING ((SELECT COUNT(H.HID) AS nr) = (select count(*) as nr2 from Cinematics))
go

CREATE OR ALTER VIEW NameImp
AS
    SELECT H.HName, H.Himportance from Heroes as H
    INNER JOIN HeroList as HL on H.HID = HL.HID
    INNER JOIN Cinematics Cin on Cin.CID = HL.CID
    GROUP BY H.HName, H.Himportance
go

SELECT * FROM NameImp
SELECT * FROM NameImportance

-- 4) Create a function that lists the name of the company, the name of the game and the title of the cinematic for all 
-- games that have the release date greater than or equal to '2000-12-02' and less than or equal to '2016-01-01'. (2 points)

CREATE or ALTER function GetGames()
RETURNS TABLE
AS
RETURN
    SELECT DISTINCT C.CompName as CompanyName, G.Gname as GameName, CIN.CName AS CinematicTitle, G.Release from Games G
    INNER JOIN Companies C ON C.CompID = G.CompID
    INNER JOIN Cinematics CIN ON CIN.GID = G.GID
    WHERE G.Release >= '1999-12-02' AND G.Release <= '2016-01-01'
GO

SELECT * FROM GetGames()





