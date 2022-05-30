CREATE PROCEDURE deleteCountry @idCountry int
WITH ENCRYPTION
AS
BEGIN
    IF @idCountry IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCountry) FROM Country WHERE idCountry = @idCountry
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Country
                    SET status = 0
                    WHERE idCountry = @idCountry
                    PRINT('Country deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The country id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO