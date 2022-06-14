CREATE PROCEDURE insertWhiskeyXCustomer @idWhiskey int, @idShop int, @idPaymentMethod int,
                                        @idCashier int, @idCourier int, @idDeliveryReviewType int,
                                        @idCustomer int, @shippingCost money, @quantity int
WITH ENCRYPTION
AS
BEGIN
    EXEC syncEmployeeTypeReplication
    EXEC syncDepartmentReplication
    EXEC syncEmployeeReplication
    EXEC syncEmployeeReviewReplication

    IF @idWhiskey IS NOT NULL AND @idShop IS NOT NULL
        AND @idPaymentMethod IS NOT NULL AND @idCashier IS NOT NULL
        AND @idCourier IS NOT NULL AND @idDeliveryReviewType IS NOT NULL
        AND @idCustomer IS NOT NULL AND @shippingCost IS NOT NULL
        AND @quantity IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
                AND status = 1) > 0
            AND (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
                AND status = 1) > 0
            AND (SELECT COUNT(idPaymentMethod) FROM PaymentMethod WHERE idPaymentMethod = @idPaymentMethod
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @idCashier
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @idCourier
                AND status = 1) > 0
            AND (SELECT COUNT(idDeliveryReviewType) FROM DeliveryReviewType WHERE idDeliveryReviewType = @idDeliveryReviewType
                AND status = 1) > 0
            AND (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @idCustomer
                AND status = 1) > 0
            AND @shippingCost >= 0
            AND @quantity > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    DECLARE @whiskeyPrice money
                    SET @whiskeyPrice = (SELECT price FROM Whiskey WHERE idWhiskey = @idWhiskey)
                    DECLARE @idSubscription int
                    SET @idSubscription = (SELECT idSubscription FROM Customer WHERE idCustomer = @idCustomer)
                    DECLARE @shippingDiscount float
                    SET @shippingDiscount = (SELECT shippingDiscount FROM Subscription WHERE idSubscription = @idSubscription)
                    DECLARE @shoppingDiscount float
                    SET @shoppingDiscount = (SELECT shoppingDiscount FROM Subscription WHERE idSubscription = @idSubscription)
                    DECLARE @shippingCostFinal money
                    SET @shippingCostFinal = (@shippingCost - (@shippingDiscount * @shippingCost))
                    DECLARE @subTotal money
                    SET @subTotal = ((@whiskeyPrice * @quantity) + @shippingCostFinal)
                    DECLARE @total money
                    SET @total = (@subTotal - (@subTotal * @shoppingDiscount))
                    INSERT INTO WhiskeyXCustomer(idWhiskey, idPaymentMethod,
                                                 idCashier, idCourier, idDeliveryReviewType,
                                                 idShop, idCustomer, shippingCost, quantity,
                                                 total, date)
                    VALUES(@idWhiskey, @idPaymentMethod, @idCashier, @idCourier, @idDeliveryReviewType,
                           @idShop, @idCustomer, @shippingCost, @quantity, @total, GETDATE())
                    PRINT('WhiskeyXCustomer inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The ids must exist and the current stock must be greater than 0.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO