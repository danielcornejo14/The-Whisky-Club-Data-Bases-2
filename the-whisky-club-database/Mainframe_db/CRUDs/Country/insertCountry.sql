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
                    DECLARE @idCurrencyString varchar(5)
                    SET @idCurrencyString = CAST(@idCurrency as varchar(5))
                    EXEC('CALL replicateInsertCountry(' + @idCurrencyString + ', ''' + @name + ''')')
                    PRINT('Country inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Country name cannot be repeated and currency id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO