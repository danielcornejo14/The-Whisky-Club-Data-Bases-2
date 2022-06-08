CREATE PROCEDURE deleteWhiskey @idWhiskey int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskey IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE UnitedStates_db.dbo.WhiskeyXShop
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE WhiskeyReview
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Image
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Whiskey
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    PRINT('Whiskey deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Whiskey id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO