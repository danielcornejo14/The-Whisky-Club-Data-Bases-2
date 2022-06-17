CREATE PROCEDURE readSale @idSale int
WITH ENCRYPTION
AS
BEGIN
    IF @idSale IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idSale) FROM Sale WHERE idSale = @idSale
            AND status = 1) > 0
        BEGIN
            SELECT idSale, idPaymentMethod, idCashier,
                   idCourier, idShop, idCustomer,
                   shippingCost, saleDiscount, subTotal,
                   total, date, status
            FROM Sale
            WHERE idSale = @idSale
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