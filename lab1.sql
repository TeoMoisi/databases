USE master
GO
CREATE DATABASE [law_comp_database]
GO


--IF OBJECT_ID('cases', 'U') IS NOT NULL
DROP TABLE case_dependency
drop TABLE client
DROP TABLE division
DROP TABLE cases;
DROP TABLE judgers;
drop TABLE judgement_hall
DROP TABLE specialised_in
DROP TABLE domains
DROP TABLE lawyer
drop TABLE company

CREATE TABLE company
(
    comp_id INT NOT NULL PRIMARY KEY,
    comp_name [VARCHAR](50) NOT NULL,
    city [VARCHAR](50) NOT NULL,
    no_of_law INT NOT NULL,
);
GO

-- A -------- Procedure to modify the type of column ------------
CREATE OR ALTER PROC modifyCompNoCol
AS
    ALTER TABLE company 
    ALTER COLUMN no_of_law [VARCHAR](50)
    PRINT 'Column type modified from int to varchar in company table.'
GO
EXEC modifyCompNoCol
DROP PROC IF EXISTS modifyCompCol
GO

CREATE OR ALTER PROC revModifyCompNoCol
AS
    ALTER TABLE company
    ALTER COLUMN no_of_law INT NOT NULL
    PRINT 'Column type modified from varchar to int in company table.'
GO
EXEC revModifyCompNoCol
DROP PROC IF EXISTS revModifyCompCol
GO
----------------------------------------

-- B --------- Procedure to add a new column in the company table ----------------
DROP PROC IF EXISTS addNewCol
GO
CREATE PROC addNewCol-- Add a new column '[years_of_activity]' to table '[company]' in schema '[dbo]'
AS
    ALTER TABLE [dbo].[company]
    ADD [years_of_activity] INT
    PRINT 'New column added in company table: years_of_activity'
GO
EXEC addNewCol
GO

DROP PROC IF EXISTS removeCol
GO
CREATE OR ALTER PROC removeCol-- Remove a column '[years_of_activity]' to table '[company]' in schema '[dbo]'
AS
    ALTER TABLE [dbo].[company]
    DROP COLUMN [years_of_activity]
    PRINT 'Column deleted in company table: years_of_activity'
GO
EXEC removeCol
GO
-----------------------------------------------------


-- DECLARE @no_of_law INT
-- SET @no_of_law = 10

-- ALTER PROC uspCompName(@no_of_law INT)
-- AS
--     SELECT comp_name FROM company WHERE no_of_law = @no_of_law
-- GO
-- EXEC uspCompName 17

CREATE TABLE lawyer
(
    l_id INT NOT NULL PRIMARY KEY,
    l_name [VARCHAR](50) NOT NULL,
    comp_id INT NOT NULL,
    FOREIGN KEY (comp_id) REFERENCES company(comp_id) ON DELETE CASCADE,
    law_age INT,
    comp_name [VARCHAR](50) NOT NULL,
    --UNIQUE(comp_name)
);
GO

DROP PROC IF EXISTS addConstraint
GO

-- C ---- Procedure to add a default constraint
CREATE OR ALTER PROC addConstraint
AS
    ALTER TABLE lawyer
    ADD CONSTRAINT df_age DEFAULT 0 FOR law_age
    PRINT 'Constraint added for law_age defalut 0 in lawyer table'
GO
EXEC addConstraint
GO

CREATE OR ALTER PROC removeConstraint
AS
    ALTER TABLE lawyer
    DROP CONSTRAINT df_age
    PRINT 'Constraint deleted for law_age defalut 0 in lawyer table'
GO
EXEC removeConstraint
DROP PROC IF EXISTS removeConstraint
GO
----------------------------------------

-- E --- Procedure to add a candidate key ------------

DROP PROC IF EXISTS addCK
GO
CREATE OR ALTER PROC addCK
AS
    ALTER TABLE company
    ADD CONSTRAINT UNQ_comp_name UNIQUE(comp_name)
    PRINT 'Condidate key added in company table: comp_name'
GO
EXEC addCK
GO


-- F ---  Procedure to add a foreign key ------
DROP PROC IF EXISTS addFK
GO
CREATE OR ALTER PROC addFK
AS
    ALTER TABLE lawyer
    ADD CONSTRAINT FK_comp_id FOREIGN KEY(comp_id) REFERENCES company
    PRINT 'Foreign key added in lawyer table: comp_id from company table.'
GO
EXEC addFK
GO

DROP PROC IF EXISTS removeFK
GO
CREATE OR ALTER PROC removeFK
AS
    ALTER TABLE lawyer
    DROP FK_comp_id
    PRINT 'Foreign key deleted in lawyer table: comp_id from company table.'
GO
EXEC removeFK
GO
---------------------------------------------

-- Remove the candidate key ----------------

CREATE OR ALTER PROC removeCK
AS
    ALTER TABLE company
    DROP UNQ_comp_name
    PRINT 'Condidate key deleted in company table: comp_name'
GO
EXEC removeCK
DROP PROC IF EXISTS removeCK
GO
----------------------------------------------

-- G -- procedure to create a table ----------
DROP PROC IF EXISTS createTbl
GO
CREATE OR ALTER PROC createTbl
AS
    CREATE TABLE domains (
        domain_name [VARCHAR](30) NOT NULL
    )
    PRINT 'New table created: domains.'
GO
EXEC createTbl
GO

-- CREATE TABLE domains
-- (
--     domain_name [VARCHAR](30)
-- );
-- GO

-- D --- Procedure to add a primary key
DROP PROC IF EXISTS addPK
GO
CREATE OR ALTER PROC addPK
AS
    ALTER TABLE domains
    ADD CONSTRAINT PK_name PRIMARY KEY(domain_name)
    PRINT 'New primary key added in domains table: domain_name.'
GO
EXEC addPK
GO

DROP PROC IF EXISTS removePK
GO
CREATE OR ALTER PROC removePK
AS
    ALTER TABLE domains
    DROP PK_name
    PRINT 'Primary key deleted in domains table: domain_name.'
GO
EXEC removePK
GO
----------------------------------------

-- Procedure to delete a table ---------

CREATE OR ALTER PROC delTbl
AS
    DROP TABLE domains
    PRINT 'Domains table deleted.'
GO
EXEC delTbl
DROP PROC IF EXISTS delTbl
-----------------------------------------

CREATE TABLE specialised_in
(
    l_id INT NOT NULL,
    domain_name [VARCHAR](30),
    FOREIGN KEY (l_id) REFERENCES lawyer(l_id) ON DELETE CASCADE,
    FOREIGN KEY (domain_name) REFERENCES domains(domain_name) ON DELETE CASCADE

);
GO


CREATE TABLE judgement_hall
(
    judgement_id INT PRIMARY KEY,
    j_address [VARCHAR](30),
    no_of_empl INT NOT NULL,
)
GO

CREATE TABLE judgers
(
    j_id INT NOT NULL PRIMARY KEY,
    j_name [VARCHAR](30),
    judgement_id INT NOT NULL,
    j_age INT,
    FOREIGN KEY (judgement_id) REFERENCES judgement_hall(judgement_id) ON DELETE CASCADE
)
GO


CREATE TABLE cases
(
    case_id INT NOT NULL PRIMARY KEY,
    condition [VARCHAR](30) NOT NULL,
    j_id INT NOT NULL,
    FOREIGN KEY (j_id) REFERENCES judgers(j_id) ON DELETE CASCADE
)
GO


CREATE TABLE division
(
    --nr_crt INT NOT NULL PRIMARY KEY,
    l_id INT NOT NULL,
    case_id INT NOT NULL,
    PRIMARY KEY (l_id,case_id) ,
    FOREIGN KEY (l_id) REFERENCES lawyer(l_id) ON DELETE CASCADE,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
)
GO



CREATE TABLE client
(
    c_id INT NOT NULL PRIMARY KEY,
    c_name [VARCHAR](30),
    c_age INT NOT NULL,
)
GO

CREATE TABLE case_dependency
(
    --nr_crt INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    client_id INT NOT NULL,
    case_id INT NOT NULL,
    PRIMARY KEY (client_id,case_id),
    FOREIGN KEY (client_id) REFERENCES client(c_id) ON DELETE CASCADE,
    FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE   
)
GO



-- INSERT INTO judgement_hall ([judgement_id], [j_address], [no_of_empl]) VALUES
-- (400, 'Cluj-Napoca',100),
-- (401, 'Bucharest', 150),
-- (402, 'Timisoara',75),
-- (403, 'Brasov',65),
-- (404, 'Oradea',70),
-- (405, 'Sibiu',50),
-- (406, 'Suceava', 45),
-- (407, 'Iasi',80),
-- (408, 'Constanta',75),
-- (409, 'Zalau',40);
-- GO

-- UPDATE judgement_hall SET j_address = 'Ploiesti' WHERE judgement_id = 408
-- GO
-- SELECT * FROM judgement_hall;
 
-- INSERT INTO client ([c_id], [c_name]) VALUES
-- (700, 'Teofana', 19),
-- (701, 'Tudor', 20),
-- (702, 'Mirela', 43),
-- (703, 'Ofelia', 23),
-- (704, 'Adrian', 23),
-- (705, 'Maria', 30),
-- (706, 'Minodora', 33),
-- (707, 'Sorin', 33),
-- (708, 'Ximena', 19),
-- (709, 'Andrada', 20),
-- (710, 'George', 25);
-- GO

-- UPDATE client SET c_name = 'Iulia' WHERE c_id < 701 OR c_id = 709
-- GO
-- SELECT * FROM client;

-- INSERT INTO company ([comp_id], [comp_name], [city], [no_of_law]) VALUES
-- (10, 'Law bros', 'Cluj-Napoca', 13),
-- (11, 'Martin&Co', 'Bucharest', 20),
-- (12, 'Morgan&Morgan', 'Cluj-Napoca', 17),
-- (13, 'Law Associates', 'Cluj-Napoca', 18),
-- (14, 'Bland&Smith','Timisoara', 9),
-- (15, 'Marvin Associates', 'Bucharest', 23),
-- (16, 'The Jaffe Law Firm', 'Timisoara', 12),
-- (17, 'RobinsIon Law', 'Bucharest', 17),
-- (18, 'AmazeLaw', 'Oradea', 19),
-- (19, 'Legato', 'Oradea', 14),
-- (20, 'Thinkvisor', 'Cluj-Napoca', 29),
-- (21, 'Counsel Bar', 'Sibiu', 15),
-- (22, 'Justice Tap', 'Suceava', 11),
-- (23, 'ThinkLawGroup', 'Suceava', 9),
-- (24, 'WillWiseSolutions', 'Iasi', 23),
-- (25, 'Clientake', 'Iasi', 19),
-- (26, 'LawMatics', 'Constanta', 24),
-- (27, 'Agreeo', 'Zalau', 17);
-- GO

-- UPDATE company SET comp_name = 'T&T Counsel' WHERE comp_id = 27 AND city LIKE 'Zalau'
-- GO
-- DELETE FROM company WHERE comp_name LIKE 'LawMatics' AND city NOT LIKE 'Cluj-Napoca' AND comp_id BETWEEN 25 AND 27
-- SELECT * FROM company ;

INSERT INTO lawyer ([l_id], [l_name], [comp_id]) VALUES
(500, 'Pop', 10),
(501, 'Borz', 10),
(502, 'Ionescu',11),
(503, 'Georgescu', 11),
(504, 'Mihalache', 12),
(505, 'Moisi', 12),
(506, 'Gog', 13),
(507, 'Biris', 13),
(508, 'Maxim', 14),
(509, 'Grigorescu', 14),
(510, 'Popescu', 15),
(511, 'Voinea', 16),
(512, 'Pascalau', 16),
(513, 'Popa', 17),
(514, 'Ionutas', 17),
(515, 'Balas', 18),
(516, 'Blaj', 19),
(517, 'Borz', 19),
(518,'Pop', 20),
(519, 'Mazareanu', 20),
(520, 'Moldovan', 21),
(521, 'Ardelean', 22),
(522, 'Oltean', 22),
(523, 'Dragos', 23),
(524, 'Moisi', 23),
(525, 'Popa', 24), 
(526, 'Mihoc', 24),
(527, 'Moldovan', 25),
(528, 'Ardelean', 25),
(529, 'Oltean', 27),
(530, 'Gogu', 27);
GO



INSERT INTO judgers ([j_id], [j_name], [judgement_id]) VALUES
(9001, 'Popescu', 400),
(9002, 'Ionescu', 405),
(9003, 'Mihut', 400),
(9004, 'Costin', 402),
(9005, 'Alexandrescu', 403),
(9006, 'Moisi', 404);
GO

INSERT INTO cases ([case_id], [condition], [j_id]) VALUES
(800, 'in process', 9004),
(801, 'done-success', 9001),
(802, 'beginning',9002),
(803, 'in process', 9003),
(804, 'done-failure',9002);
GO

DELETE FROM cases WHERE case_id >= 804 OR j_id > 9002

INSERT INTO case_dependency ([client_id], [case_id]) VALUES
(700, 801),
(700, 802),
(702,802),
(702,804);
GO



INSERT INTO division ([nr_crt], [l_id], [case_id]) VALUES
(1, 7001, 1223),
(2, 7001, 3465);
GO


INSERT INTO domains([domain_name]) VALUES
('IT security'),
('Marine rights'),
('Writing rights'),
('Pharnchise'),
('Inventions');
GO


INSERT INTO specialised_in([domain_name], [l_id]) VALUES
('IT security', 500),
('IT security', 501),
('Marine rights', 500),
('Writing rights', 510),
('Pharnchise', 500),
('Inventions', 501),
('Marine rights', 502);
GO

