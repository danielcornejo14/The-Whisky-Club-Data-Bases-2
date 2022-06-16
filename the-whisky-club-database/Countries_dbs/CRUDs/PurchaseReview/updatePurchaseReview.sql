CREATE PROCEDURE updatePurchaseReview @idPurchaseReview int, @idWhiskeyXCustomer int,
                                      @comment varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idPurchaseReview IS NOT NULL AND
       @idWhiskeyXCustomer IS NOT NULL AND @comment IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(comment) FROM PurchaseReview WHERE comment = @comment) = 0
            AND (SELECT COUNT(idWhiskeyXCustomer) FROM WhiskeyXCustomer WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer) > 0
            AND (SELECT COUNT(idPurchaseReview) FROM PurchaseReview WHERE idPurchaseReview = @idPurchaseReview) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE PurchaseReview
                    SET idWhiskeyXCustomer = @idWhiskeyXCustomer,
                        comment = @comment,
                        date = GETDATE()
                    WHERE idPurchaseReview = @idPurchaseReview
                    PRINT('PurchaseReview updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The comment cannot be repeated and the ids must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO