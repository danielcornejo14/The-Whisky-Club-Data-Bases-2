CREATE PROCEDURE readDeliveryReviewType @idDeliveryReviewType int
WITH ENCRYPTION
AS
BEGIN
    IF @idDeliveryReviewType IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idDeliveryReviewType) FROM DeliveryReviewType WHERE idDeliveryReviewType = @idDeliveryReviewType
             AND status = 1) > 0
        BEGIN
            SELECT idDeliveryReviewType, name, status
            FROM DeliveryReviewType
            WHERE idDeliveryReviewType = @idDeliveryReviewType
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