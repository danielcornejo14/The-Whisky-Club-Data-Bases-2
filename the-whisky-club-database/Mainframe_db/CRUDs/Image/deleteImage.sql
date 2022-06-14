CREATE PROCEDURE deleteImage @idImage int
WITH ENCRYPTION
AS
BEGIN
    IF @idImage IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idImage) FROM Image WHERE idImage = @idImage
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete image in Mainframe
                    UPDATE Image
                    SET status = 0
                    WHERE idImage = @idImage
                    ------------------------
                    --Delete image replication in countries
                    UPDATE UnitedStates_db.dbo.Image
                    SET status = 0
                    WHERE idImage = @idImage
                    UPDATE Scotland_db.dbo.Image
                    SET status = 0
                    WHERE idImage = @idImage
                    UPDATE Ireland_db.dbo.Image
                    SET status = 0
                    WHERE idImage = @idImage
                    ------------------------
                    PRINT('Image deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Image id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO