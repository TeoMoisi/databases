drop table Case_dependency
drop table Client
drop table Cases


create table Client (
    c_id int not null primary key,
    c_age int unique,
    c_name varchar(25)
)

create table Cases (
    case_id int not null primary key,
    condition int --1(success), 2(fail)
)

create table Case_dependency (
    nr_crt int not null primary key,
    c_id int foreign key references Client(c_id) on delete cascade,
    case_id int foreign key references Cases(case_id) on delete cascade
)

go

create or alter procedure Insert_into AS
BEGIN
    DECLARE @name VARCHAR(25)
    DECLARE @index int = 1
    while @index < 1000
    BEGIN
        set @name = concat('client',cast(@index as varchar(25)))
        insert into Client(c_id, c_age, c_name) 
        values(@index, @index+25,@name)

        if @index % 3 = 1
            insert into Cases(case_id, condition) 
            values(@index,1)
        ELSE
            insert into Cases(case_id, condition) 
            values(@index,2)

        insert into Case_dependency(nr_crt, c_id, case_id) 
        values(@index,@index,@index)

        set @index = @index + 1
    END
END

EXEC Insert_into

-- Clustered index scan

select * from Client
SELECT * FROM Cases
SELECT * from Case_dependency

-- clustered index seek
select * from Client where c_id > 50

exec sp_helpindex Client

-- nonclustered index scan

SELECT c_age from Client ORDER BY c_age

-- nonclustered index seek -- key lookup.

SELECT * from Client where c_age = 50
SELECT * FROM Cases where condition = 1


-- b

SELECT * FROM Cases WHERE condition = 1

CREATE NONCLUSTERED INDEX cond_nonclustered ON Cases(condition)
-- ALTER INDEX cond_nonclustered ON Cases DISABLE
DROP INDEX Cases.cond_nonclustered

go
-- c
CREATE OR ALTER VIEW Joining 
AS
    SELECT nr_crt FROM Case_dependency
    INNER JOIN Client cl 
    ON cl.c_id = Case_dependency.c_id
GO


GO


--FOE EVERY CLIENT, PLEASE SHOW ALL THE CASES AND THE STATE
CREATE OR ALTER VIEW View_c
AS
    SELECT C.c_name, cases.condition       
    FROM Client C
    INNER JOIN Case_dependency D ON C.c_id = D.c_id
    INNER JOIN Cases cases ON CASES.case_id = D.case_id
GO

SELECT * FROM View_c

SELECT * FROM Joining