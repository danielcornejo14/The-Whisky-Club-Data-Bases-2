CREATE PROCEDURE deletePresentation @idPresentation int
WITH ENCRYPTION
AS
BEGIN
    IF @idPresentation IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPresentation) FROM Presentation WHERE idPresentation = @idPresentation
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Whiskey
                    SET status = 0
                    WHERE idPresentation = @idPresentation
                    UPDATE Presentation
                    SET status = 0
                    WHERE idPresentation = @idPresentation
                    PRINT('Presentation deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The presentation id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO