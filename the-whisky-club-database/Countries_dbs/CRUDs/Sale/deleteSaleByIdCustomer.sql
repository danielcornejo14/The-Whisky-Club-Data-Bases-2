CREATE PROCEDURE deleteSaleByIdCustomer @idCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @idCustomer IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCustomer) FROM Sale WHERE idCustomer = @idCustomer
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
                    INNER JOIN Customer C ON S.idCustomer = C.idCustomer
                    WHERE C.idCustomer = @idCustomer
                    ---------------------------------------------
                    --Delete purchase review
                    UPDATE PurchaseReview
                    SET status = 0
                    FROM PurchaseReview
                    INNER JOIN Sale S2 ON S2.idSale = PurchaseReview.idSale
                    INNER JOIN Customer C2 ON S2.idCustomer = C2.idCustomer
                    WHERE C2.idCustomer = @idCustomer
                    ----------------------------------------------
                    --Delete Sale
                    UPDATE Sale
                    SET status = 0
                    WHERE idCustomer = @idCustomer
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
            RAISERROR('The customer id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO