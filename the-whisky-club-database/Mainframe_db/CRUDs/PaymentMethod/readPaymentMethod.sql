CREATE PROCEDURE readPaymentMethod @idPaymentMethod int
WITH ENCRYPTION
AS
BEGIN
    IF @idPaymentMethod IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPaymentMethod) FROM PaymentMethod WHERE idPaymentMethod = @idPaymentMethod
             AND status = 1) > 0
        BEGIN
            SELECT idPaymentMethod, name, status
            FROM PaymentMethod
            WHERE idPaymentMethod = @idPaymentMethod
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