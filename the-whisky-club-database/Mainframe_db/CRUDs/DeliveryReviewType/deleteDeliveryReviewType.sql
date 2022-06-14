CREATE PROCEDURE deleteDeliveryReviewType @pIdDeliveryReviewType int
WITH ENCRYPTION
AS
BEGIN
    IF @pIdDeliveryReviewType IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idDeliveryReviewType) FROM DeliveryReviewType WHERE idDeliveryReviewType = @pIdDeliveryReviewType
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete whiskey x customer in USA
                    EXEC [UnitedStates_db].[dbo].[deleteWhiskeyXCustomerByIdDeliveryReview] @idDeliveryReviewType = @pIdDeliveryReviewType
                    ---------------------------------------
                    --Delete whiskey x customer in Ireland
                    EXEC [Ireland_db].[dbo].[deleteWhiskeyXCustomerByIdDeliveryReview] @idDeliveryReviewType = @pIdDeliveryReviewType
                    ---------------------------------------
                    --Delete whiskey x customer in Scotland
                    EXEC [Scotland_db].[dbo].[deleteWhiskeyXCustomerByIdDeliveryReview] @idDeliveryReviewType = @pIdDeliveryReviewType
                    ---------------------------------------
                    --Delete DeliveryReviewType in mainframe
                    UPDATE DeliveryReviewType
                    SET status = 0
                    WHERE idDeliveryReviewType = @pIdDeliveryReviewType
                    ---------------------------------------
                    --Delete replication DeliveryReviewType in countries
                    UPDATE UnitedStates_db.dbo.DeliveryReviewType
                    SET status = 0
                    WHERE idDeliveryReviewType = @pIdDeliveryReviewType
                    UPDATE Scotland_db.dbo.DeliveryReviewType
                    SET status = 0
                    WHERE idDeliveryReviewType = @pIdDeliveryReviewType
                    UPDATE Ireland_db.dbo.DeliveryReviewType
                    SET status = 0
                    WHERE idDeliveryReviewType = @pIdDeliveryReviewType
                    ---------------------------------------
                    PRINT('DeliveryReviewType deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The DeliveryReviewType id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO