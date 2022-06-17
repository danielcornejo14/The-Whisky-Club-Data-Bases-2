CREATE PROCEDURE deleteSaleByIdPaymentMethod @idPaymentMethod int
WITH ENCRYPTION
AS
BEGIN
    IF @idPaymentMethod IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPaymentMethod) FROM Sale WHERE idPaymentMethod = @idPaymentMethod
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    ---------------------------------------------
                    --Delete whiskey x sale
                    UPDATE WhiskeyXSale
                    SET status = 0
                    FROM WhiskeyXSale
                    INNER JOIN Sale S ON WhiskeyXSale.idSale = S.idSale
                    INNER JOIN PaymentMethod PM ON S.idPaymentMethod = PM.idPaymentMethod
                    WHERE PM.idPaymentMethod = @idPaymentMethod
                    ---------------------------------------------
                    --Delete purchase review
                    UPDATE PurchaseReview
                    SET status = 0
                    FROM PurchaseReview
                    INNER JOIN Sale S2 ON PurchaseReview.idSale = S2.idSale
                    INNER JOIN PaymentMethod P ON S2.idPaymentMethod = P.idPaymentMethod
                    WHERE P.idPaymentMethod = @idPaymentMethod
                    ----------------------------------------------
                    --Delete sale
                    UPDATE Sale
                    SET status = 0
                    WHERE idPaymentMethod = @idPaymentMethod
                    ----------------------------------------------
                    PRINT('Sale deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The PaymentMethod id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO