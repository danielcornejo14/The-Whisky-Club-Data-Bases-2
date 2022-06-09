CREATE PROCEDURE updatePresentation @idPresentation int, @description varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idPresentation IS NOT NULL AND @description IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idPresentation) FROM Presentation WHERE idPresentation = @idPresentation
            AND status = 1) > 0
            AND (SELECT COUNT(description) FROM Presentation WHERE description = @description) = 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Presentation
                    SET description = @description
                    WHERE idPresentation = @idPresentation
                    UPDATE UnitedStates_db.dbo.Presentation
                    SET description = @description
                    WHERE idPresentation = @idPresentation
                    UPDATE Scotland_db.dbo.Presentation
                    SET description = @description
                    WHERE idPresentation = @idPresentation
                    UPDATE Ireland_db.dbo.Presentation
                    SET description = @description
                    WHERE idPresentation = @idPresentation
                    PRINT('Presentation updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The presentation description cannot be repeated and the presentation id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO