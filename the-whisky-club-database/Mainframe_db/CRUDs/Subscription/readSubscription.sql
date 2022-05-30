CREATE PROCEDURE readSubscription @idSubscription int
WITH ENCRYPTION
AS
BEGIN
    IF @idSubscription IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idSubscription) FROM Subscription WHERE idSubscription = @idSubscription AND
             status = 1) > 0
        BEGIN
            SELECT idSubscription, idShop, name, shoppingDiscount, shippingDiscount, status
            FROM Subscription
            WHERE idSubscription = @idSubscription
        END
        ELSE
        BEGIN
            RAISERROR('The subscription id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO