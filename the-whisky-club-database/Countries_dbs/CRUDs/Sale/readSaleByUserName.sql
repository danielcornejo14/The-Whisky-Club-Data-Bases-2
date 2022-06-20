CREATE PROCEDURE readSaleByUserName @userName varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @userName IS NOT NULL
    BEGIN
        DECLARE @idCustomer int
        SET @idCustomer = (SELECT (idCustomer) FROM Customer WHERE userName = @userName)
        IF (SELECT COUNT(idSale) FROM Sale WHERE idCustomer = @idCustomer
            AND status = 1) > 0
        BEGIN
            SELECT idSale, idPaymentMethod, idCashier,
                   idCourier, idShop, idCustomer,
                   shippingCost, saleDiscount, subTotal,
                   total, date, status
            FROM Sale
            WHERE idCustomer = @idCustomer
        END
        ELSE
        BEGIN
            RAISERROR('No customer sales recorded.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END