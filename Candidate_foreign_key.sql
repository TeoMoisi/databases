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
GO
----------------------------------------------
