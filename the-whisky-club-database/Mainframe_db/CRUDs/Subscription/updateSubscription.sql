CREATE PROCEDURE updateSubscription @idSubscription int, @name varchar(64), @idShop int,
                                    @shoppingDiscount float, @shippingDiscount float
WITH ENCRYPTION
AS
BEGIN
    IF @idSubscription IS NOT NULL AND @name IS NOT NULL AND
       @idShop IS NOT NULL AND @shoppingDiscount IS NOT NULL
       AND @shippingDiscount IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idSubscription) FROM Subscription WHERE idSubscription = @idSubscription
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM Subscription WHERE name = @name) = 0
            AND (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
            AND status = 1) > 0
            AND @shoppingDiscount >= 0
            AND @shippingDiscount >= 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Subscription
                    SET idShop = @idShop,
                        name = @name,
                        shoppingDiscount = @shoppingDiscount,
                        shippingDiscount = @shippingDiscount
                    WHERE idSubscription = @idSubscription
                    PRINT('Subscription updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The subscription name cannot be repeated, the ids must exist and the discounts must be 0 or greater.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO