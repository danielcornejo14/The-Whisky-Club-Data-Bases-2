CREATE PROCEDURE readWhiskeyXCustomer @idWhiskeyXCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyXCustomer IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyXCustomer) FROM WhiskeyXCustomer WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer
            AND status = 1) > 0
        BEGIN
            SELECT idWhiskeyXCustomer, idWhiskey, idPaymentMethod,
                   idCashier, idCourier, idDeliveryReviewType,
                   idShop, idCustomer, shippingCost, quantity,
                   total, date, status
            FROM WhiskeyXCustomer
            WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer
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