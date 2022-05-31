CREATE PROCEDURE updateDeliveryReviewType @idDeliveryReviewType int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idDeliveryReviewType IS NOT NULL AND @name IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idDeliveryReviewType) FROM DeliveryReviewType WHERE idDeliveryReviewType = @idDeliveryReviewType
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM DeliveryReviewType WHERE name = @name) = 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE DeliveryReviewType
                    SET name = @name
                    WHERE idDeliveryReviewType = @idDeliveryReviewType
                    PRINT('DeliveryReviewType updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The DeliveryReviewType name cannot be repeated and the DeliveryReviewType id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO