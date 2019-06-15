CREATE DATABASE Test
GO
USE Test
GO

Drop TABLE HotelList
DROP TABLE Hotel

DROP TABLE HolidayDest
DROP TABLE Booking
drop table TravelPack
drop table Office

CREATE TABLE Hotel (
    Hid int PRIMARY key identity(1,1),
    Hname VARCHAR(50),
    Hstars int
)

CREATE TABLE Office (
    Oid int PRIMARY key IDENTITY(1,1),
    Address VARCHAR(50)
)

CREATE TABLE HolidayDest (
    HDid int PRIMARY key IDENTITY(1,1),
    HDname VARCHAR(50),
    SecScore int
)

CREATE TABLE HotelList (
    HLid int PRIMARY key IDENTITY(1,1),
    Hid int REFERENCES Hotel(Hid),
    HDid int REFERENCES HolidayDest(HDid)
)

CREATE TABLE TravelPack (
    TPid int PRIMARY key IDENTITY(1,1),
    TPStart date,
    TPEnd date,
    PricePers int not null,
    Hid int REFERENCES Hotel(Hid)
)

CREATE TABLE Booking (
    Bid int PRIMARY key IDENTITY(1,1),
    TPid int REFERENCES TravelPack(TPid),
    Oid int REFERENCES Office(Oid),
    NoPers int,
    Bdate date 
)

INSERT into HolidayDest([HDname], [SecScore]) VALUES ('Dubai', 1),
                                                    ('Rio', 2)

INSERT into HolidayDest([HDname], [SecScore]) VALUES ('Romania', 0),
                                                    ('Maroc', 2)                                                   

INSERT into Hotel([Hname], [Hstars]) VALUES ('Burj', 7), ('Continental', 5)
INSERT into Hotel([Hname], [Hstars]) VALUES ('Ramada', 5), ('Hilton', 5)
SELECT * FROM Hotel
select * from HolidayDest

Insert into HotelList([Hid], [HDid]) VALUES (1,1), (2,2)
Insert into HotelList([Hid], [HDid]) VALUES (3,1), (4,2)


SELECT * from HotelList

INSERT INTO TravelPack([TPStart], [TPEnd], [PricePers], [Hid]) VALUES ('2019-01-03', '2019-01-10', 300, 2)
INSERT INTO TravelPack([TPStart], [TPEnd], [PricePers], [Hid]) VALUES ('2019-02-10', '2019-02-17', 500, 3)
SELECT * FROM TravelPack

INSERT into Office([Address]) VALUES ('Bucharest')
INSERT into Office([Address]) VALUES ('Cluj')
select * from Office

INSERT INTO Booking([TPid], [Oid], [NoPers], [Bdate]) VALUEs (1, 1, 3, '2018-12-20')
INSERT INTO Booking([TPid], [Oid], [NoPers], [Bdate]) VALUEs (2, 2, 7, '2018-12-25')
select * from Booking

go
-- 2)
CREATE or ALTER PROC DelUnsafe
AS
    DECLARE @hotelid INT
    Declare @holidest int
    declare @trid int
    declare @bookid int

    -- set @holidest = (select HolidayDest.HDid from HolidayDest WHERE HolidayDest.SecScore = 2)
    -- set @hotelid = (select HotelList.Hid from HotelList WHERE HotelList.HDid = @holidest)
    -- set @trid = (select TravelPack.TPid from TravelPack where TravelPack.Hid = @hotelid)
    set @trid = (SElect TP.TPid FROM TravelPack as TP
                    INNER JOIN HotelList as HL on HL.Hid = TP.Hid
                    INNER JOIN HolidayDest as HD ON HD.HDid = HL.HDid
                    WHERE HD.SecScore = 2)
    --set @bookid = (select Booking.Bid from Booking where Booking.TPid = @trid)

    DELETE from Booking where Booking.Bid in (select Booking.Bid from Booking where Booking.TPid = @trid)
go

EXEC DelUnsafe
GO

-- 3)
GO
CREATE OR ALTER VIEW GetOffices
as
    SELECT O.Oid, O.Address from Office as O
    INNER JOIN Booking as B on B.Oid = O.Oid
    INNER JOIN TravelPack as TP on TP.TPid = B.TPid
    GROUP BY O.Oid, O.Address
GO

SELECT * FROM GetOffices

SElect TP.TPid FROM TravelPack as TP
INNER JOIN HotelList as HL on HL.Hid = TP.Hid
INNER JOIN HolidayDest as HD ON HD.HDid = HL.HDid
WHERE HD.SecScore = 2

--4)

go
CREATE or ALTER function GetHotels(@pers int)
RETURNS TABLE
AS
RETURN
    SELECT Hname, Hstars from Hotel where Hotel.Hid in (
        select TP.Hid from TravelPack TP INNER JOIN Booking B on TP.TPid = B.TPid
        Where B.NoPers > @pers
    ) 

GO

SELECT * from GetHotels(5)
