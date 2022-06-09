CREATE PROCEDURE updateImage @idImage int, @idWhiskey int, @image varbinary(max)
WITH ENCRYPTION
AS
BEGIN
    IF @idImage IS NOT NULL AND @idWhiskey IS NOT NULL
        AND @image IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idImage) FROM Image WHERE idImage = @idImage
            AND status = 1) > 0
            AND (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Image
                    SET idWhiskey = @idWhiskey,
                        image = @image
                    WHERE idImage = @idImage
                    UPDATE UnitedStates_db.dbo.Image
                    SET idWhiskey = @idWhiskey,
                        image = @image
                    WHERE idImage = @idImage
                    UPDATE Scotland_db.dbo.Image
                    SET idWhiskey = @idWhiskey,
                        image = @image
                    WHERE idImage = @idImage
                    UPDATE Ireland_db.dbo.Image
                    SET idWhiskey = @idWhiskey,
                        image = @image
                    WHERE idImage = @idImage
                    PRINT('Image updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The image id and whiskey id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO