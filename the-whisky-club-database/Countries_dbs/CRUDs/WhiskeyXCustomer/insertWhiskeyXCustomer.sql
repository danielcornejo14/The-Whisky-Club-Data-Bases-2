CREATE PROCEDURE insertWhiskeyXCustomer @pIdWhiskey int, @pIdShop int, @pIdPaymentMethod int,
                                        @pIdCashier int, @pIdCourier int, @pIdDeliveryReviewType int,
                                        @pIdCustomer int, @pShippingCost money, @pQuantity int
WITH ENCRYPTION
AS
BEGIN
    EXEC syncEmployeeTypeReplication
    EXEC syncDepartmentReplication
    EXEC syncEmployeeReplication
    EXEC syncEmployeeReviewReplication

    IF @pIdWhiskey IS NOT NULL AND @pIdShop IS NOT NULL
        AND @pIdPaymentMethod IS NOT NULL AND @pIdCashier IS NOT NULL
        AND @pIdCourier IS NOT NULL AND @pIdDeliveryReviewType IS NOT NULL
        AND @pIdCustomer IS NOT NULL AND @pShippingCost IS NOT NULL
        AND @pQuantity IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @pIdWhiskey
                AND status = 1) > 0
            AND (SELECT COUNT(idShop) FROM Shop WHERE idShop = @pIdShop
                AND status = 1) > 0
            AND (SELECT COUNT(idPaymentMethod) FROM PaymentMethod WHERE idPaymentMethod = @pIdPaymentMethod
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @pIdCashier
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @pIdCourier
                AND status = 1) > 0
            AND (SELECT COUNT(idDeliveryReviewType) FROM DeliveryReviewType WHERE idDeliveryReviewType = @pIdDeliveryReviewType
                AND status = 1) > 0
            AND (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @pIdCustomer
                AND status = 1) > 0
            AND @pShippingCost >= 0
            AND @pQuantity > 0)
        BEGIN
            --The availability of the whiskey is checked in the shop.
            IF (SELECT COUNT(*) FROM WhiskeyXShop WHERE idShop = @pIdShop
                AND idWhiskey = @pIdWhiskey AND currentStock > 0 AND status = 1) > 0
            BEGIN
                 BEGIN TRANSACTION
                    BEGIN TRY
                        DECLARE @whiskeyPrice money
                        SET @whiskeyPrice = (SELECT price FROM Whiskey WHERE idWhiskey = @pIdWhiskey)
                        DECLARE @shippingDiscount float
                        DECLARE @idSubscription int
                        SET @idSubscription = (SELECT idSubscription FROM Customer WHERE idCustomer = @pIdCustomer)
                        DECLARE @shoppingDiscount float
                        DECLARE @pShippingCostFinal money
                        DECLARE @subTotal money
                        DECLARE @total money
                        IF @idSubscription = 1 --Tier normal subscription
                        BEGIN
                            SET @shippingDiscount = 0
                            SET @shoppingDiscount = 0
                        END
                        ELSE IF @idSubscription = 2 --Tier short glass subscription
                        BEGIN
                            SET @shippingDiscount = 0
                            SET @shoppingDiscount = 0.05
                        END
                        ELSE IF @idSubscription = 3 --Tier gleincairn
                        BEGIN
                            SET @shippingDiscount = 0.2
                            SET @shoppingDiscount = 0.1
                        END
                        ELSE IF @idSubscription = 4 --Tier master distiller
                        BEGIN
                            SET @shippingDiscount = 1
                            SET @shoppingDiscount = 0.3
                        END
                        SET @pShippingCostFinal = (@pShippingCost - (@shippingDiscount * @pShippingCost))
                        SET @subTotal = ((@whiskeyPrice * @pQuantity) + @pShippingCostFinal)
                        SET @total = (@subTotal - (@subTotal * @shoppingDiscount))
                        INSERT INTO WhiskeyXCustomer(idWhiskey, idPaymentMethod,
                                                     idCashier, idCourier, idDeliveryReviewType,
                                                     idShop, idCustomer, shippingCost, quantity,
                                                     total, date)
                        VALUES(@pIdWhiskey, @pIdPaymentMethod, @pIdCashier, @pIdCourier, @pIdDeliveryReviewType,
                               @pIdShop, @pIdCustomer, @pShippingCost, @pQuantity, @total, GETDATE())
                        --Decrease whiskey current stock
                        UPDATE WhiskeyXShop
                        SET currentStock = currentStock - @pQuantity
                        WHERE idWhiskey = @pIdWhiskey
                        --------------------------------
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
                RAISERROR('The requested whiskey is not available in the shop.', 11, 1)
            END
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