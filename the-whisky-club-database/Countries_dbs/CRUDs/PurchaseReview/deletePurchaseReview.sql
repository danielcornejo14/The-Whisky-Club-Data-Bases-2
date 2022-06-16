CREATE PROCEDURE deletePurchaseReview @idPurchaseReview int
WITH ENCRYPTION
AS
BEGIN
    IF @idPurchaseReview IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPurchaseReview) FROM PurchaseReview WHERE idPurchaseReview = @idPurchaseReview) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE PurchaseReview
                    SET status = 0
                    WHERE idPurchaseReview = @idPurchaseReview
                    PRINT('PurchaseReview deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO