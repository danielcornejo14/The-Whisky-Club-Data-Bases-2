CREATE OR ALTER PROCEDURE selectPaymentMethod
WITH ENCRYPTION
AS
BEGIN
    SELECT idPaymentMethod, name
    FROM PaymentMethod
    WHERE status = 1
END
