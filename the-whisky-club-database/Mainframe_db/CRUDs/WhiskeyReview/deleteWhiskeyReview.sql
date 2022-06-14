CREATE PROCEDURE deleteWhiskeyReview @idWhiskeyReview int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyReview IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyReview) FROM WhiskeyReview WHERE idWhiskeyReview = @idWhiskeyReview
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete whiskey review in Mainframe
                    UPDATE WhiskeyReview
                    SET status = 0
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    ----------------------------
                    --Delete whiskey review replication in countries
                    UPDATE UnitedStates_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    UPDATE Ireland_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    UPDATE Scotland_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    ----------------------------
                    PRINT('WhiskeyReview deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyReview id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO