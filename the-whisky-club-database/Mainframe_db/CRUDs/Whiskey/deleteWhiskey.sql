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
                    --Delete WhiskeyXShop in Countries
                    UPDATE UnitedStates_db.dbo.WhiskeyXShop
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Scotland_db.dbo.WhiskeyXShop
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Ireland_db.dbo.WhiskeyXShop
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    ----------------------------
                    --Delete whiskeyXCustomer in Countries
                    UPDATE UnitedStates_db.dbo.WhiskeyXCustomer
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Scotland_db.dbo.WhiskeyXCustomer
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Ireland_db.dbo.WhiskeyXCustomer
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    ----------------------------
                    --Delete whiskeyXReview in Mainframe
                    UPDATE WhiskeyReview
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    --Delete whiskeyXReview replication in countries
                    UPDATE UnitedStates_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Ireland_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Scotland_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    ---------------------------
                    --Delete image in Mainframe
                    UPDATE Image
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    ----------------------------
                    --Delete image replication in countries
                    UPDATE UnitedStates_db.dbo.Image
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Scotland_db.dbo.Image
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Ireland_db.dbo.Image
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    ----------------------------
                    --Delete whiskey in Mainframe
                    UPDATE Whiskey
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    ----------------------------
                    --Delete whiskey replication in Countries
                    UPDATE Scotland_db.dbo.Whiskey
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE Ireland_db.dbo.Whiskey
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    UPDATE UnitedStates_db.dbo.Whiskey
                    SET status = 0
                    WHERE idWhiskey = @idWhiskey
                    ----------------------------
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