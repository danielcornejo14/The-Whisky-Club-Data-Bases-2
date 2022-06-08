CREATE PROCEDURE insertCurrency @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @name IS NOT NULL
    BEGIN
        IF (SELECT COUNT(name) FROM Currency WHERE name = @name) = 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO Currency(name)
                    VALUES (@name)
                    INSERT INTO UnitedStates_db.dbo.Currency(name)
                    VALUES (@name)
                    INSERT INTO Scotland_db.dbo.Currency(name)
                    VALUES (@name)
                    INSERT INTO Ireland_db.dbo.Currency(name)
                    VALUES (@name)
                    COMMIT TRANSACTION
                    --Replication in the Employees_db.
                    EXEC('CALL replicateInsertCurrency(''' + @name + ''')') AT MYSQL_SERVER
                    PRINT('Currency inserted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The currency name cannot be repeated.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO