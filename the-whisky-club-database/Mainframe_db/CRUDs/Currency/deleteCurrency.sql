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
                    --CURSOR CON EXEC deleteCountry
                    UPDATE Currency
                    SET status = 0
                    WHERE idCurrency = @idCurrency
                    PRINT('Currency deleted.')
                    COMMIT TRANSACTION
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