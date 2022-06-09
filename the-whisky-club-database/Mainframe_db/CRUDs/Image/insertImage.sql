CREATE PROCEDURE insertImage @idWhiskey int, @image varbinary(max)
WITH ENCRYPTION
AS
BEGIN
    IF @image IS NOT NULL AND @idWhiskey IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO Image(idWhiskey, image)
                    VALUES (@idWhiskey , @image)
                    INSERT INTO UnitedStates_db.dbo.Image(idWhiskey, image)
                    VALUES (@idWhiskey , @image)
                    INSERT INTO Ireland_db.dbo.Image(idWhiskey, image)
                    VALUES (@idWhiskey , @image)
                    INSERT INTO Scotland_db.dbo.Image(idWhiskey, image)
                    VALUES (@idWhiskey , @image)
                    PRINT('Image inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The whiskey id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO