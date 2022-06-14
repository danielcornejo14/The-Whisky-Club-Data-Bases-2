CREATE PROCEDURE deleteCurrency @idCurrency int
WITH ENCRYPTION
AS
BEGIN
    IF @idCurrency IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCurrency) FROM Currency WHERE idCurrency = @idCurrency
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete whiskey cursor
                    DECLARE @idWhiskeyCursor int, @idCurrencyCursor int
                    DECLARE whiskeyCursor CURSOR FOR SELECT
                    idWhiskey, idCurrency FROM Whiskey
                    OPEN whiskeyCursor
                    FETCH NEXT FROM whiskeyCursor INTO @idWhiskeyCursor, @idCurrencyCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idCurrencyCursor = @idCurrency
                            EXEC deleteWhiskey @idWhiskey = @idWhiskeyCursor
                        FETCH NEXT FROM whiskeyCursor INTO @idWhiskeyCursor, @idCurrencyCursor
                    END
                    CLOSE whiskeyCursor
                    DEALLOCATE whiskeyCursor
                    --Delete country cursor
                    DECLARE @idCountryCursor int
                    DECLARE countryCursor CURSOR FOR SELECT
                    idCountry, idCurrency FROM Country
                    OPEN countryCursor
                    FETCH NEXT FROM countryCursor INTO @idCountryCursor, @idCurrencyCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idCurrencyCursor = @idCurrency
                            EXEC deleteCountry @idCountry = @idCountryCursor
                        FETCH NEXT FROM countryCursor INTO @idCountryCursor, @idCurrencyCursor
                    END
                    CLOSE countryCursor
                    DEALLOCATE countryCursor
                    --------------------------
                    --Delete currency in mainframe
                    UPDATE Currency
                    SET status = 0
                    WHERE idCurrency = @idCurrency
                    --------------------------
                    --Delete currency replication in countries
                    UPDATE Ireland_db.dbo.Currency
                    SET status = 0
                    WHERE idCurrency = @idCurrency
                    UPDATE UnitedStates_db.dbo.Currency
                    SET status = 0
                    WHERE idCurrency = @idCurrency
                    UPDATE Scotland_db.dbo.Currency
                    SET status = 0
                    WHERE idCurrency = @idCurrency
                    --------------------------
                    COMMIT TRANSACTION
                    --Delete currency in employees db
                    DECLARE @idCurrencyString varchar(5)
                    SET @idCurrencyString = CAST(@idCurrency as varchar(5))
                    EXEC('CALL replicateDeleteCurrency(' + @idCurrencyString + ')') AT MYSQL_SERVER
                    PRINT('Currency deleted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The currency id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO