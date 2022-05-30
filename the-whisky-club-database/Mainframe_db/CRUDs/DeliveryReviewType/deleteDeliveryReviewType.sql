CREATE PROCEDURE deleteDeliveryReviewType @idDeliveryReviewType int
WITH ENCRYPTION
AS
BEGIN
    IF @idDeliveryReviewType IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idDeliveryReviewType) FROM DeliveryReviewType WHERE idDeliveryReviewType = @idDeliveryReviewType
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE DeliveryReviewType
                    SET status = 0
                    WHERE idDeliveryReviewType = @idDeliveryReviewType
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