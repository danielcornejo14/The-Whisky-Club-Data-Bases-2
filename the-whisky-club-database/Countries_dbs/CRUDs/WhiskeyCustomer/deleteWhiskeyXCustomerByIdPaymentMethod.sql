CREATE PROCEDURE deleteWhiskeyXCustomerByIdPaymentMethod @idPaymentMethod int
WITH ENCRYPTION
AS
BEGIN
    IF @idPaymentMethod IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPaymentMethod) FROM WhiskeyXCustomer WHERE idPaymentMethod = @idPaymentMethod
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyXCustomer
                    SET status = 0
                    WHERE idPaymentMethod = @idPaymentMethod
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
            RAISERROR('The PaymentMethod id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO