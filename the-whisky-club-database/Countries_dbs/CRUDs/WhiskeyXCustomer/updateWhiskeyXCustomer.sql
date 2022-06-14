CREATE PROCEDURE updateWhiskeyXCustomer @idWhiskey int, @idShop int, @idPaymentMethod int,
                                        @idCashier int, @idCourier int, @idDeliveryReviewType int,
                                        @idCustomer int, @shippingCost money, @quantity int,
                                        @idWhiskeyXCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF (SELECT COUNT(*)
        FROM (SELECT idEmployee, idDepartment,
                     idEmployeeType, name, lastName1,
                     lastName2, localSalary, dollarSalary,
                     userName, password, status
              FROM mysql_server...employee
              EXCEPT
              SELECT idEmployee, idDepartment,
                     idEmployeeType, name, lastName1,
                     lastName2, localSalary, dollarSalary,
                     userName, password, status
              FROM Employee) as t) > 0 --There is a difference between the tables, so the sync is necessary.
    BEGIN
        EXEC syncEmployeeTypeReplication
        EXEC syncDepartmentReplication
        EXEC syncEmployeeReplication
        EXEC syncEmployeeReviewReplication
    END

    IF @idWhiskey IS NOT NULL AND @idShop IS NOT NULL
        AND @idPaymentMethod IS NOT NULL AND @idCashier IS NOT NULL
        AND @idCourier IS NOT NULL AND @idDeliveryReviewType IS NOT NULL
        AND @idCustomer IS NOT NULL AND @shippingCost IS NOT NULL
        AND @quantity IS NOT NULL AND @idWhiskeyXCustomer IS NOT NULL
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
            AND @quantity > 0
            AND (SELECT COUNT(idWhiskeyXCustomer) FROM WhiskeyXCustomer WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer
                AND status = 1) > 0)
        BEGIN
            --The availability of the whiskey is checked in the shop.
            IF (SELECT COUNT(*) FROM WhiskeyXShop WHERE idShop = @idShop
                AND idWhiskey = @idWhiskey AND currentStock > 0 AND status = 1) > 0
            BEGIN
                BEGIN TRANSACTION
                    BEGIN TRY
                        DECLARE @whiskeyPrice money
                        SET @whiskeyPrice = (SELECT price FROM Whiskey WHERE idWhiskey = @idWhiskey)
                        DECLARE @shippingDiscount float
                        DECLARE @idSubscription int
                        SET @idSubscription = (SELECT idSubscription FROM Customer WHERE idCustomer = @idCustomer)
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
                        SET @pShippingCostFinal = (@shippingDiscount - (@shippingDiscount * @shippingDiscount))
                        SET @subTotal = ((@whiskeyPrice * @quantity) + @pShippingCostFinal)
                        SET @total = (@subTotal - (@subTotal * @shoppingDiscount))
                        UPDATE WhiskeyXCustomer
                        SET idWhiskey = @idWhiskey,
                            idPaymentMethod = @idPaymentMethod,
                            idCashier = @idCashier,
                            idCourier = @idCourier,
                            idDeliveryReviewType = @idDeliveryReviewType,
                            idShop = @idShop,
                            idCustomer = @idCustomer,
                            shippingCost = @shippingCost,
                            quantity = @quantity,
                            total = @total,
                            date = GETDATE()
                        WHERE idWhiskeyXCustomer = @idWhiskeyXCustomer
                        --Decrease whiskey current stock
                        UPDATE WhiskeyXShop
                        SET currentStock = currentStock - @quantity
                        WHERE idWhiskey = @idWhiskey
                        --------------------------------
                        PRINT('WhiskeyXCustomer updated.')
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