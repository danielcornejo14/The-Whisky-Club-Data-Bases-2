CREATE PROCEDURE deleteSale @idSale int
WITH ENCRYPTION
AS
BEGIN
    IF @idSale IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idSale) FROM Sale WHERE idSale = @idSale
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    ---------------------------------------------
                    --Delete whiskey x sale
                    UPDATE WhiskeyXSale
                    SET status = 0
                    WHERE idSale = @idSale
                    ---------------------------------------------
                    --Delete purchase review
                    UPDATE PurchaseReview
                    SET status = 0
                    WHERE idSale = @idSale
                    ----------------------------------------------
                    --Delete whiskey x customer
                    UPDATE Sale
                    SET status = 0
                    WHERE idSale = @idSale
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
            RAISERROR('The Sale id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO