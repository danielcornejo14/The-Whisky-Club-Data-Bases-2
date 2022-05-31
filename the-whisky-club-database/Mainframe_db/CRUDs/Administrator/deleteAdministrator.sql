CREATE PROCEDURE deleteAdministrator @idAdministrator int
WITH ENCRYPTION
AS
BEGIN
    IF @idAdministrator IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idAdministrator) FROM Administrator WHERE idAdministrator = @idAdministrator
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Administrator
                    SET status = 0
                    WHERE idAdministrator = @idAdministrator
                    PRINT('Administrator deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Administrator id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO