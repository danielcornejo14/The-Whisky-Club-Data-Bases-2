CREATE PROCEDURE insertPurchaseReview @idSale int, @comment varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idSale IS NOT NULL AND @comment IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idSale) FROM Sale WHERE idSale = @idSale) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO PurchaseReview(idSale, comment, date)
                    VALUES (@idSale , @comment, GETDATE())
                    PRINT('PurchaseReview inserted.')
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