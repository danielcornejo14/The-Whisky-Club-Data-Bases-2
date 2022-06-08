CREATE PROCEDURE updateCurrency @idCurrency int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idCurrency IS NOT NULL AND @name IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idCurrency) FROM Currency WHERE idCurrency = @idCurrency
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM Currency WHERE name = @name) = 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Currency
                    SET name = @name
                    WHERE idCurrency = @idCurrency
                    UPDATE UnitedStates_db.dbo.Currency
                    SET name = @name
                    WHERE idCurrency = @idCurrency
                    UPDATE Scotland_db.dbo.Currency
                    SET name = @name
                    WHERE idCurrency = @idCurrency
                    UPDATE Ireland_db.dbo.Currency
                    SET name = @name
                    WHERE idCurrency = @idCurrency
                    COMMIT TRANSACTION
                    --Replication in the Employees_db.
                    DECLARE @idCurrencyString varchar(5)
                    SET @idCurrencyString = CAST(@idCurrency as varchar(5))
                    EXEC('CALL replicateUpdateCurrency(' + @idCurrencyString + ', ' + '''' + @name + '''' + ')') AT MYSQL_SERVER
                    PRINT('Currency updated.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The currency name cannot be repeated and the currency id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO