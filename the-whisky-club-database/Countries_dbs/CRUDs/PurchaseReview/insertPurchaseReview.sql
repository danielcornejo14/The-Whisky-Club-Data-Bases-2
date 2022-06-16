CREATE PROCEDURE insertPurchaseReview @idWhiskeyXCustomer int, @comment varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyXCustomer IS NOT NULL AND @comment IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(comment) FROM PurchaseReview WHERE comment = @comment) = 0
            AND (SELECT COUNT(idWhiskeyXCustomer) FROM WhiskeyXCustomer WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO PurchaseReview(idWhiskeyXCustomer, comment, date)
                    VALUES (@idWhiskeyXCustomer , @comment, GETDATE())
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
            RAISERROR('The comment cannot be repeated and the id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO