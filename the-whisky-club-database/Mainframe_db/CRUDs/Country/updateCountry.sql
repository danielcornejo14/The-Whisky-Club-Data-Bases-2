CREATE PROCEDURE updateCountry @idCountry int, @name varchar(64), @idCurrency int
WITH ENCRYPTION
AS
BEGIN
    IF @idCountry IS NOT NULL AND @name IS NOT NULL AND
       @idCurrency IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idCountry) FROM Country WHERE idCountry = @idCountry
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM Country WHERE name = @name) = 0
            AND (SELECT COUNT(idCurrency) FROM Currency WHERE idCurrency = @idCurrency
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Country
                    SET idCurrency = @idCurrency,
                        name = @name
                    WHERE idCountry = @idCountry
                    UPDATE UnitedStates_db.dbo.Country
                    SET idCurrency = @idCurrency,
                        name = @name
                    WHERE idCountry = @idCountry
                    UPDATE Scotland_db.dbo.Country
                    SET idCurrency = @idCurrency,
                        name = @name
                    WHERE idCountry = @idCountry
                    UPDATE Ireland_db.dbo.Country
                    SET idCurrency = @idCurrency,
                        name = @name
                    WHERE idCountry = @idCountry
                    COMMIT TRANSACTION
                    --Country replication in the employees_db
                    DECLARE @idCountryString varchar(5)
                    SET @idCountryString = CAST(@idCountry as varchar(5))
                    DECLARE @idCurrencyString varchar(5)
                    SET @idCurrencyString = CAST(@idCurrency as varchar(5))
                    EXEC('CALL replicateUpdateCountry(' + @idCountryString + ', ' + @idCurrencyString + ', ''' + @name + ''')') AT MYSQL_SERVER
                    PRINT('Country updated.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The country name cannot be repeated and both ids must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO