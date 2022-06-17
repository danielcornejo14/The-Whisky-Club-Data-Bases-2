CREATE PROCEDURE deleteSaleByIdShop @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idShop) FROM Sale WHERE idShop = @idShop
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
                    INNER JOIN Shop PM ON S.idShop = PM.idShop
                    WHERE PM.idShop = @idShop
                    ---------------------------------------------
                    --Delete purchase review
                    UPDATE PurchaseReview
                    SET status = 0
                    FROM PurchaseReview
                    INNER JOIN Sale S2 ON PurchaseReview.idSale = S2.idSale
                    INNER JOIN Shop P ON S2.idShop = P.idShop
                    WHERE P.idShop = @idShop
                    ----------------------------------------------
                    --Delete sale
                    UPDATE Sale
                    SET status = 0
                    WHERE idShop = @idShop
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
            RAISERROR('The Shop id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO