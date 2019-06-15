create DATABASE test_example
GO
use test_example
go


create table Universities (
	Uid int primary key identity(1, 1),
	name varchar(50),
	ranking int 
)

create table Teams (
	Tid int primary key identity(1, 1),
	name varchar(50),
	Uid int references Universities(Uid),
)

create table Researchers (
	Rid int primary key identity(1, 1),
	name varchar(50),
	Tid int references Teams(Tid)
)

create table Eagles (
	Eid int primary key identity(1, 1),
	weight int,
	yearOfBirth int,
	Tid int references Teams(Tid)
)

create table Sensor (
	Sid int primary key identity(1, 1),
	description varchar(50),
	Eid int references Eagles(Eid)
)

select * from Teams
select * from Universities
select * from Eagles
select * from Researchers
select * from Sensor

go


insert into Universities values ('Babes Bolyai', 1)
insert into Universities values ('UTCN', 2)
insert into Universities values ('Other', 11)

insert into Teams values ('Other', 3)
insert into Teams values
('Team1', 1),
('Team2', 1),
('Team3', 2);

insert into Researchers values 
('Tudor Maxim', 1),
('Gabi Matko', 1),
('Maza Dragos', 2),
('Mircean Alex', 1);
go


create or alter procedure insertEagle(@weigth INT, @year INT, @Tid INT) 
as
	declare @noTeams int
	set @noTeams = 0
	select @noTeams = Count(*) from Teams t where t.Tid = @Tid
	if @noTeams = 0 
		print 'The team does not exist'
	else
		insert into Eagles values (@weigth, @year, @Tid)
go

go
execute insertEagle 2, 3, 4
go


insert into Eagles values
(2, 3, 2),
(1, 3, 1)

go
create or alter view teamsFromTop10 as
	select r.TeamName from (
		select u.Uid, u.name, T.Tid, t.name as TeamName from Universities u inner join Teams t on t.Uid = u.Uid
		where u.ranking < 11
	) r inner join Eagles e on e.Tid = r.Tid
go

select * from teamsFromTop10

go

insert into Sensor values
('asdlas', 1),
('asdasfa', 1),
('asdasdsa', 2)

go
create or alter function eaglesWithSensors(@S int) returns table as
return 
	select Eid, weight from Eagles where Eid IN (
		select e.Eid from Eagles e inner join Sensor s on e.Eid = s.Eid
		group by e.Eid
		having count(*) > @S
	)
go

select * from eaglesWithSensors(1)