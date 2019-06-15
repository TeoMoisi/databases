USE master
GO
SELECT * FROM lawyer;

INSERT INTO judgement_hall ([judgement_id], [j_address], [no_of_empl]) VALUES
(400, 'Cluj-Napoca',100),
(401, 'Bucharest', 150),
(402, 'Timisoara',75),
(403, 'Brasov',65),
(404, 'Oradea',70),
(405, 'Sibiu',50),
(406, 'Suceava', 45),
(407, 'Iasi',80),
(408, 'Constanta',75),
(409, 'Zalau',40);
GO

UPDATE judgement_hall SET j_address = 'Ploiesti' WHERE judgement_id = 408 AND  no_of_empl <= 100
GO
SELECT * FROM judgement_hall;
 
INSERT INTO client ([c_id], [c_name], [c_age]) VALUES
(700, 'Teofana', 19),
(701, 'Tudor', 20),
(702, 'Mirela', 43),
(703, 'Ofelia', 23),
(704, 'Adrian', 23),
(705, 'Maria', 30),
(706, 'Minodora', 33),
(707, 'Sorin', 33),
(708, 'Ximena', 19),
(709, 'Andrada', 20),
(710, 'George', 25),
(711, 'Teofana', 26);
GO

UPDATE client SET c_name = 'Iulia' WHERE c_id < 701 OR c_id = 709 and c_age IN (20, 21, 22)
GO
SELECT * FROM client;

INSERT INTO company ([comp_id], [comp_name], [city], [no_of_law], [years_of_activity]) VALUES
(10, 'Law bros', 'Cluj-Napoca', 13, 10);
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
GO
SELECT * FROM company

SELECT * FROM company WHERE no_of_law LIKE '13'

UPDATE company SET comp_name = 'T&T Counsel' WHERE comp_id = 27 AND city LIKE 'Zalau' AND no_of_law IS NOT NULL
GO
DELETE FROM company WHERE comp_name LIKE 'LawMatics' AND city NOT LIKE 'Cluj-Napoca' AND comp_id BETWEEN 25 AND 27
SELECT * FROM company ;

INSERT INTO lawyer ([l_id], [l_name], [comp_id], [comp_name]) VALUES
(500, 'Pop', 10, 'Law bros');

INSERT INTO lawyer ([l_id], [l_name], [comp_id], [comp_name]) VALUES
(100, 'Mirela', 10, 'Law bros');

INSERT INTO lawyer ([l_id], [l_name], [comp_id], [comp_name]) VALUES
(102, 'Mircea', 10, 'Law bros');

INSERT INTO lawyer ([l_id], [l_name], [comp_id], [comp_name]) VALUES
(102, 'Teo', 10, 'Law bros');

INSERT INTO lawyer ([l_id], [l_name], [comp_id], [comp_name]) VALUES
(105, 'Moisi', 10, 'Law bros');
-- (501, 'Borz', 10, 29),
-- (502, 'Ionescu',11, 45),
-- (503, 'Georgescu', 11, 45),
-- (504, 'Mihalache', 12, 30),
-- (505, 'Moisi', 12, 25),
-- (506, 'Gog', 13, 26),
-- (507, 'Biris', 13, 28),
-- (508, 'Maxim', 14, 27),
-- (509, 'Grigorescu', 14, 50),
-- (510, 'Popescu', 15, 49),
-- (511, 'Voinea', 16, 55),
-- (512, 'Pascalau', 16, NULL),
-- (513, 'Borz', 16, 47);
-- (514, 'Ionutas', 17),
-- (515, 'Balas', 18),
-- (516, 'Blaj', 19),
-- (517, 'Borz', 19),
-- (518,'Pop', 20),
-- (519, 'Mazareanu', 20),
-- (520, 'Moldovan', 21),
-- (521, 'Ardelean', 22),
-- (522, 'Oltean', 22),
-- (523, 'Dragos', 23),
-- (524, 'Moisi', 23),
-- (525, 'Popa', 24), 
-- (526, 'Mihoc', 24),
-- (527, 'Moldovan', 25),
-- (528, 'Ardelean', 25),
-- (529, 'Oltean', 27),
-- (530, 'Gogu', 27);
GO


DELETE FROM lawyer WHERE l_name LIKE 'Pascalau' AND law_age IS NULL
GO
SELECT * FROM lawyer;

---------------------NO. A-------------------
--QUESTION: PLEASE SHOW ALL THE COMPANIES AND ITS CORRESPPNDING CITY FROM BUCHAREST OR CLUJ-NAPOCA.
--UNION QUERY
SELECT comp_name, city FROM company WHERE city LIKE 'Bucharest'
UNION ALL
SELECT comp_name, city FROM company WHERE city LIKE 'Cluj-Napoca'

--OR QUERY
SELECT comp_name, city FROM company WHERE city LIKE 'Bucharest' OR city LIKE 'Cluj-Napoca' ORDER BY city ASC

-------------END NO. A---------------------

-------------NO. B-------------------------

--QUESTION: Show all the lawyers who have more than 20, but less than 30 age yo.
--INTERSECT QUERY
SELECT l_name, law_age FROM lawyer WHERE law_age >= 20
INTERSECT
SELECT l_name, law_age FROM lawyer WHERE law_age < 30

--IN QUERY
SELECT l_name, law_age FROM lawyer WHERE law_age IN (20, 21, 22, 23, 24, 25, 26, 27, 28, 29) ORDER BY law_age ASC

-------------END NO. B-----------------------

-------------NO. C---------------------------

--Knowing that a lawyer retires at the age of 60, show all the lawyers who have less than 10 age except those who have less than 15 age until retiring
--EXCEPT QUERY
SELECT l_id, l_name FROM lawyer WHERE (60 - law_age) < 15
EXCEPT
SELECT l_id, l_name FROM lawyer WHERE (60 - law_age) < 10

--NOT IN QUERY
SELECT l_id, l_name FROM lawyer WHERE l_id NOT IN (500, 501, 502, 503, 504, 505, 506, 507, 508, 511, 512, 514, 515, 516, 517, 518, 519, 520) ORDER BY l_id DESC

-------------END NO. C-------------------------

INSERT INTO judgers ([j_id], [j_name], [judgement_id], [j_age]) VALUES
(9001, 'Popescu', 400, 45),
(9002, 'Ionescu', 405, 43),
(9003, 'Mihut', 400, 44),
(9004, 'Costin', 402, 48),
(9005, 'Alexandrescu', 403, 51),
(9006, 'Moisi', 404, 54);
GO

INSERT INTO cases ([case_id], [condition], [j_id]) VALUES
(800, 'in process', 9004),
(801, 'done-success', 9001),
(802, 'beginning',9002),
(803, 'in process', 9003),
(804, 'done-failure',9002),
(805, 'done-success', 9006),
(806, 'in process', 9005),
(807, 'done-success', 9004);
GO

INSERT INTO division ([l_id],[case_id]) VALUES
(500, 801),
(501, 802),
(502, 801),
(500,807),
(504, 806),
(504, 805),
(505, 803);
GO

DELETE FROM cases WHERE case_id >= 804 OR j_id > 9002

INSERT INTO case_dependency ([client_id], [case_id]) VALUES
(700, 801),
(700, 802),
(702,802);
--(702,804);
GO

--------------------------NO. G--------------------
--FROM CLAUSE
--Please show all the lawyers older than 35 who have a case
SELECT D.l_id from division D INNER JOIN (
    SELECT * FROM lawyer L WHERE L.law_age >= 35
) t on D.l_id = t.l_id

--Please show all the judgers who will retire in less than 10 years and have a case 'in process'
SELECT C.j_id from cases C INNER JOIN (
    SELECT * FROM judgers J WHERE (60 - J.j_age) >= 10
) t on C.j_id = t.j_id AND C.condition like 'in process'

--------------------END NO. G------------------------


---------------------NO. D--------------------
--JOIN QUERIES
--PLEASE GIVE ALL THE CLIENTS NAMES AND THE STATE OF THEIR CASE, CASE ID AND THE LAWYER WHO WORKED AT THE CORRESPONDING CASE
SELECT DISTINCT C.c_name, CASES.condition, CASES.case_id, L.l_id
FROM client C
INNER JOIN case_dependency D ON C.c_id = D.client_id
INNER JOIN cases CASES ON CASES.case_id = D.case_id
INNER JOIN division  DIV ON DIV.case_id = CASES.case_id
INNER JOIN lawyer L on L.l_id = DIV.l_id 

--FOE EVERY CLIENT, PLEASE SHOW ALL THE CASES AND THE STATE, INCLUDING CLIENTS WITH NO CASES YET
SELECT C.c_name, CASES.condition       
FROM client C
LEFT JOIN case_dependency D ON C.c_id = D.client_id
LEFT JOIN cases CASES ON CASES.case_id = D.case_id


SELECT DISTINCT C.c_name, CASES.condition
FROM client C
RIGHT JOIN case_dependency D ON C.c_id = D.client_id
RIGHT JOIN cases CASES ON CASES.case_id = D.case_id

--Find all the lawyers and theirs corresponding companies
SELECT L.l_name, C.comp_name FROM company C
RIGHT JOIN lawyer L ON L.comp_id = C.comp_id

--Find all companies and theirs lawyiers, including companies with no lawyers
SELECT C.comp_name, L.l_name FROM company C
FULL JOIN lawyer L ON L.comp_id = C.comp_id

SELECT DISTINCT C.c_name, CASES.condition
FROM client C
FULL JOIN case_dependency D ON C.c_id = D.client_id
FULL JOIN cases CASES ON CASES.case_id = D.case_id
--WHERE cases.condition IS NOT NULL

--------------END NO. D-------------------------


-------------NO. F---------------------
--WHERE AND IN QUERY
--PLEASE SHOW ALL THE LAWYERS FROM CLUJ
SELECT L.l_name FROM lawyer L where EXISTS
(SELECT COMP.comp_id FROM company COMP WHERE L.comp_id = COMP.comp_id AND COMP.city LIKE 'Cluj-Napoca')

--Show all the judgers who work in Bucharest
SELECT J.j_name FROM judgers J WHERE EXISTS 
(SELECT JUD.judgement_id FROM judgement_hall JUD where J.judgement_id = JUD.judgement_id AND JUD.j_address LIKE 'Sibiu' )

---------END NO. F----------------------

---------NO. E-----------------------------
--PLEASE SHOW ALL THE LAWYERS FROM CLUJ
SELECT L.l_name FROM lawyer L where L.comp_id IN
(SELECT COMP.comp_id FROM company COMP WHERE COMP.city LIKE 'Cluj-Napoca')

--Select all the cases id and their condition which were judged by a judger from Cluj-Napoca
SELECT C.case_id, C.condition FROM cases C WHERE C.j_id IN 
(SELECT J.j_id FROM judgers J where J.judgement_id IN 
(SELECT HALL.judgement_id FROM judgement_hall HALL WHERE HALL.j_address LIKE 'Cluj-Napoca'))
--------------END NO. E--------------------

INSERT INTO domains([domain_name]) VALUES
('IT security'),
('Marine rights'),
('Writing rights'),
('Pharnchise'),
('Inventions');
GO
SElECT * FROM domains


INSERT INTO specialised_in([domain_name], [l_id]) VALUES
('IT security', 500),
('IT security', 501),
('IT security', 511),
('IT security', 509),
('Marine rights', 503),
('Writing rights', 505),
('Pharnchise', 500),
('Inventions', 501),
('Marine rights', 506),
('Writing rights', 511),
('Pharnchise', 503),
('Inventions', 501),
('Marine rights', 502);
--('Inventions', NULL);
GO

--Select all the distinct specialisations where the l_id is not null
SELECT DISTINCT D.domain_name FROM specialised_in D WHERE D.l_id IS NOT NULL
SELECT * FROM specialised_in
SELECT * FROM domains

-----------------NO. H-------------------
--HOW MANY COMPANIES ARE IN EACH CITY?
SELECT COMP.city, COUNT(*) FROM company COMP GROUP BY COMP.city

--GROUP BY: Find the age of the youngest lawyer from each company
SELECT L.comp_id, MIN(law_age) FROM lawyer L
GROUP BY L.comp_id

--Find the age of the oldest lawyer from each company who is older than 25 and there are at least 2 such lawyers.
SELECT L.comp_id, MAX(law_age) AS MaxAge FROM lawyer L
WHERE L.law_age >= 25
GROUP BY L.comp_id
HAVING COUNT(*) >= 2

--Find the average age of the lawyers who are at least 25 years old for each company with at least 2 lawyers

SELECT L.comp_id, AVG(law_age) AS AvgAge FROM lawyer L
WHERE L.law_age >= 25
GROUP BY L.comp_id
HAVING 1 < (SELECT COUNT(*) FROM lawyer L2 WHERE L.comp_id = L2.comp_id)

--Select the companies who have at least 2 lawyers older than 25 yo.
SELECT C.comp_name,C.comp_id FROM company C WHERE C.comp_id IN (
    SELECT L.comp_id FROM lawyer L
WHERE L.law_age >= 25
GROUP BY L.comp_id
HAVING 1 < (SELECT COUNT(*) FROM lawyer L2 WHERE L.comp_id = L2.comp_id)
)

SELECT C.comp_name,C.comp_id FROM company C WHERE C.comp_id IN (
    SELECT L.comp_id FROM lawyer L
WHERE L.law_age >= 25
GROUP BY L.comp_id
)
--Find the average age of the judgers who are at least 45 years old for each judgement hall with at least 2 judgers
SELECT J.judgement_id, AVG(J.j_age) AS AvgAge FROM judgers J
WHERE J.j_age >= 40
GROUP BY J.judgement_id
HAVING 1 < (SELECT COUNT(*) FROM judgers J2 WHERE J.judgement_id = J2.judgement_id)

--------------END NO. H-------------------------


--Find the names of the top 3 lawyers who are specialised in the 'IT security' domain and have more than 5 ages until retiring
SELECT TOP 3 L.l_name FROM lawyer L
WHERE L.l_id IN (
    SELECT SPEC.l_id
    FROM specialised_in SPEC WHERE SPEC.domain_name LIKE 'IT security' AND (60 - L.law_age) > 5
)

--EXISTS in a subquery from WHERE clause
SELECT top 3 L.l_name FROM lawyer L
WHERE EXISTS (
    SELECT * FROM specialised_in SPEC WHERE L.l_id = SPEC.l_id AND SPEC.domain_name LIKE 'IT security'
)

--same but for marine rights
SELECT TOP 2 L.l_name FROM lawyer L
WHERE EXISTS (
    SELECT * FROM specialised_in SPEC WHERE L.l_id = SPEC.l_id AND SPEC.domain_name LIKE 'Marine rights'
)


---------------NO. I---------------------


--Find the lawyers who worked on the case with id = 801

SELECT L.l_name FROM lawyer L
WHERE L.l_id = ANY (
    SELECT D.l_id FROM division D
    WHERE D.case_id = 801
)

SELECT L.l_name FROM lawyer L
WHERE L.l_id IN (
    SELECT D.l_id FROM division D
    WHERE D.case_id = 801
)

--DID NOT WORK ON IT
SELECT L.l_name FROM lawyer L
WHERE L.l_id <> ALL (
    SELECT D.l_id FROM division D
    WHERE D.case_id = 801
)

SELECT L.l_name FROM lawyer L
WHERE L.l_id NOT IN (
    SELECT D.l_id FROM division D
    WHERE D.case_id = 801
)


--Find the name and age of the oldest judge

SELECT J.j_name, J.j_age from judgers J
WHERE J.j_age = ANY (
    SELECT MAX(J2.j_age) FROM judgers J2
)

SELECT TOP 1 J.j_name, J.j_age from judgers J
WHERE J.j_age > ANY (
    SELECT J2.j_age FROM judgers J2
) ORDER BY j_age DESC 


--Find top 3 companies who have more employees than some company from Cluj
SELECT TOP 3 COMP.comp_name, COMP.city FROM company COMP
WHERE COMP.no_of_law > ANY (
    SELECT COMP2.no_of_law
    FROM company COMP2
    WHERE COMP2.city like 'Cluj-Napoca'
)

SELECT TOP 3 COMP.comp_name, COMP.city FROM company COMP
WHERE COMP.no_of_law > ANY (
    SELECT MIN(COMP2.no_of_law)
    FROM company COMP2
    WHERE COMP2.city like 'Cluj-Napoca'
)

--Find top 3 companies who have more employees than all the companies from Iasi
SELECT TOP 3 COMP.comp_name, COMP.city FROM company COMP
WHERE COMP.no_of_law > ALL (
    SELECT COMP2.no_of_law
    FROM company COMP2
    WHERE COMP2.city like 'Iasi'
)