CREATE PROCEDURE insertCountry @idCurrency int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @name IS NOT NULL AND @idCurrency IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(name) FROM Country WHERE name = @name) = 0
            AND (SELECT COUNT(idCurrency) FROM Currency WHERE idCurrency = @idCurrency
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO Country(idCurrency, name)
                    VALUES (@idCurrency , @name)
                    INSERT INTO UnitedStates_db.dbo.Country(idCurrency, name)
                    VALUES (@idCurrency , @name)
                    INSERT INTO Scotland_db.dbo.Country(idCurrency, name)
                    VALUES (@idCurrency , @name)
                    INSERT INTO Ireland_db.dbo.Country(idCurrency, name)
                    VALUES (@idCurrency , @name)
                    COMMIT TRANSACTION
                    --The inserted country is replicated in the Employees_db.
                    DECLARE @idCurrencyString varchar(5)
                    SET @idCurrencyString = CAST(@idCurrency as varchar(5))
                    EXEC('CALL replicateInsertCountry(' + @idCurrencyString + ', ''' + @name + ''')') AT MYSQL_SERVER
                    PRINT('Country inserted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Country name cannot be repeated and the currency id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO