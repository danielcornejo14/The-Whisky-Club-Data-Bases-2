CREATE PROCEDURE deleteWhiskeyXCustomer @idWhiskeyXCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyXCustomer IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyXCustomer) FROM WhiskeyXCustomer WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    ---------------------------------------------
                    --Delete purchase review
                    UPDATE PurchaseReview
                    SET status = 0
                    WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer
                    ----------------------------------------------
                    --Delete whiskey x customer
                    UPDATE WhiskeyXCustomer
                    SET status = 0
                    WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer
                    ----------------------------------------------
                    PRINT('WhiskeyXCustomer deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyXCustomer id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO