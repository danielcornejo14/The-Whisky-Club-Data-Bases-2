CREATE PROCEDURE updatePaymentMethod @idPaymentMethod int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idPaymentMethod IS NOT NULL AND @name IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idPaymentMethod) FROM PaymentMethod WHERE idPaymentMethod = @idPaymentMethod
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM PaymentMethod WHERE name = @name) = 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE PaymentMethod
                    SET name = @name
                    WHERE idPaymentMethod = @idPaymentMethod
                    PRINT('PaymentMethod updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The PaymentMethod name cannot be repeated and the PaymentMethod id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO