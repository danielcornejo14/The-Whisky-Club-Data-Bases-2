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
                    --Delete whiskey cursor
                    DECLARE @idWhiskeyCursor int, @idPresentationCursor int
                    DECLARE whiskeyCursor CURSOR FOR SELECT
                    idWhiskey, idPresentation FROM Whiskey
                    OPEN whiskeyCursor
                    FETCH NEXT FROM whiskeyCursor INTO @idWhiskeyCursor, @idPresentationCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idPresentationCursor = @idPresentation
                            EXEC deleteWhiskey @idWhiskey = @idWhiskeyCursor
                        FETCH NEXT FROM whiskeyCursor INTO @idWhiskeyCursor, @idPresentationCursor
                    END
                    CLOSE whiskeyCursor
                    DEALLOCATE whiskeyCursor
                    ----------------------------------
                    --Delete presentation in Mainframe
                    UPDATE Presentation
                    SET status = 0
                    WHERE idPresentation = @idPresentation
                    ----------------------------------
                    --Delete presentation replication in countries
                    UPDATE UnitedStates_db.dbo.Presentation
                    SET status = 0
                    WHERE idPresentation = @idPresentation
                    UPDATE Scotland_db.dbo.Presentation
                    SET status = 0
                    WHERE idPresentation = @idPresentation
                    UPDATE Ireland_db.dbo.Presentation
                    SET status = 0
                    WHERE idPresentation = @idPresentation
                    ---------------------------------
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