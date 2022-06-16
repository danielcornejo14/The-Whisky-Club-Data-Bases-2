CREATE PROCEDURE readPurchaseReview @idPurchaseReview int
WITH ENCRYPTION
AS
BEGIN
    IF @idPurchaseReview IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPurchaseReview) FROM PurchaseReview WHERE idPurchaseReview = @idPurchaseReview
             AND status = 1) > 0
        BEGIN
            SELECT idPurchaseReview, idWhiskeyXCustomer, comment, date, status
            FROM PurchaseReview
            WHERE idPurchaseReview = @idPurchaseReview
        END
        ELSE
        BEGIN
            RAISERROR('The PurchaseReview id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO