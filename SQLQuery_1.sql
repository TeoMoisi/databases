CREATE OR ALTER VIEW selCity AS
SELECT comp_name, city FROM company WHERE city LIKE 'Test_company'
GO

CREATE VIEW twoTbl AS
SELECT D.l_id from division D INNER JOIN (
    SELECT * FROM lawyer L WHERE L.law_age >= 35
) t on D.l_id = t.l_id
GO

CREATE VIEW grView AS
SELECT C.comp_name,C.comp_id FROM company C WHERE C.comp_id IN (
    SELECT L.comp_id FROM lawyer L
WHERE L.law_age >= 25
GROUP BY L.comp_id
HAVING 1 < COUNT(*)
)
GO

CREATE OR ALTER VIEW getTypes AS
    SELECT r.TableName, r.ColumnName, t.name, t.system_type_id FROM sys.types t INNER JOIN (
        SELECT o.name AS TableName, c.name AS ColumnName, c.system_type_id
        FROM sys.objects o INNER JOIN sys.columns c
        ON o.object_id = c.object_id
        WHERE o.type = 'U'
    ) r ON  t.system_type_id = r.system_type_id
GO

CREATE OR ALTER FUNCTION create_insert(@id INT, @test_int INT, @test_varchar VARCHAR(100), @tableName VARCHAR(100)) RETURNS VARCHAR(1000) AS
BEGIN
	DECLARE @table_name VARCHAR(100);
	DECLARE @column_name VARCHAR(100);
	DECLARE @column_type VARCHAR(100);
	DECLARE @Insert VARCHAR(1000);
	DECLARE @first_time INT;
	SET @first_time = 1;

	DECLARE myCursor CURSOR FOR SELECT TableName, ColumnName, name FROM getTypes WHERE TableName = @tableName
	OPEN myCursor 
	FETCH myCursor INTO @table_name, @column_name, @column_type
	SET @Insert = 'INSERT INTO ' + @table_name + ' VALUES (' + CAST(@id AS VARCHAR(10)) + ',';
	FETCH myCursor INTO @table_name, @column_name, @column_type
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @column_type = 'varchar'
			SET @Insert = @Insert + '''' + @test_varchar + '''';
		ELSE 
			SET @Insert = @Insert + CAST(@test_int AS VARCHAR(10));
		FETCH myCursor INTO @table_name, @column_name, @column_type
		IF @@FETCH_STATUS = 0
			SET @Insert = @Insert + ',';
		ELSE
			SET @Insert = @Insert + ')';
	END
	CLOSE myCursor
	DEALLOCATE myCursor
	RETURN @Insert
END
GO

-- DECLARE @insert NVARCHAR(1000)
-- SET @insert = dbo.create_insert(6, 2, 'Test', 'Coach')
-- EXEC sp_executesql @insert
-- SELECT * FROM Coach


CREATE OR ALTER PROC Test1 AS

    INSERT INTO TestRuns([Description], [StartAt], [EndAt]) VALUES
    ('Test1 to insert data in company and lawyer', null, null);

    declare @testid int
	select @testid=TestRunId
	from TestRuns
	where TestRunId=(select max(TestRunId) from TestRuns)

    declare @starttime datetime
	set @starttime =GETDATE()

    DECLARE @start_time DATETIME
    SET @start_time = SYSDATETIME()

    DECLARE @index INT
    SET @index = 1
    WHILE (@index < 1000)
    BEGIN
        DECLARE @insert NVARCHAR(1000)
        SET @insert = dbo.create_insert(@index, @index + 2, 'Test_company', 'company')
        EXEC sp_executesql @insert
    END

    DECLARE @end_time DATETIME
    SET @end_time = SYSDATETIME()
    insert into TestRunTables values(@testid,1,@start_time,@end_time)

    SET @start_time = SYSDATETIME()

    DECLARE @index2 INT
    SET @index2 = 1001
    WHILE (@index2 < 2000)
    BEGIN
        DECLARE @insert2 NVARCHAR(1000)
        SET @insert = dbo.create_insert(@index2, @index + 2, 'Test_lawyer', 'lawyer')
        EXEC sp_executesql @insert2
    END
    SET @end_time = SYSDATETIME()
    insert into TestRunTables values(@testid,2,@start_time,@end_time)

    SET @start_time = SYSDATETIME()
    SELECT * FROM selCity
    SET @end_time = SYSDATETIME()
    insert into TestRunViews values(@testid,1,@start_time,@end_time)

    declare @endtime datetime
	set @endtime=GETDATE()
	update TestRuns set StartAt=@starttime where TestRunId=@testid
	update TestRuns set EndAt=@endtime where TestRunId=@testid
GO

EXEC Test1

INSERT INTO Tables([Name]) VALUES
('company'),
('lawyer'),
('division');

INSERT INTO Views([Name]) VALUES
('selCity'),
('twoTbl'),
('grView');

INSERT INTO Tests([Name]) VALUES
('Test1'),
('Test2'),
('Test3');

INSERT INTO TestTables([TestID], [TableID], [NoOfRows], [Position]) VALUES
(1,1,1000,1),
(1,2,1000,2);

INSERT INTO TestViews([TestID], [ViewID]) VALUES
(1,1);
GO


SELECT * FROM Tables
SELECT * FROM Views
SELECT * FROM Tests
SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
SELECT * FROM company