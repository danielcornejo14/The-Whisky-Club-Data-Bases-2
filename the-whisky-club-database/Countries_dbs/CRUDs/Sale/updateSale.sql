CREATE PROCEDURE updateSale @idSale int,
                            @idShop int, @idPaymentMethod int,
                            @idCashier int, @idCourier int,
                            @idCustomer int, @shippingCost money,
                            @saleDiscount money, @subTotal money

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

    IF @idSale IS NOT NULL AND @idShop IS NOT NULL
        AND @idPaymentMethod IS NOT NULL AND @idCashier IS NOT NULL
        AND @idCourier IS NOT NULL
        AND @idCustomer IS NOT NULL AND @shippingCost IS NOT NULL
        AND @saleDiscount IS NOT NULL AND @subTotal IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
                AND status = 1) > 0
            AND (SELECT COUNT(idPaymentMethod) FROM PaymentMethod WHERE idPaymentMethod = @idPaymentMethod
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @idCashier
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @idCourier
                AND status = 1) > 0
            AND (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @idCustomer
                AND status = 1) > 0
            AND @shippingCost >= 0
            AND @subTotal >= 0
            AND @saleDiscount >= 0
            AND (SELECT COUNT(idSale) FROM Sale WHERE idSale = @idSale
                AND status = 1) > 0)
        BEGIN
            DECLARE @total money
            SET @total = (@subTotal - @saleDiscount + @shippingCost)
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Sale
                    SET idPaymentMethod = @idPaymentMethod,
                        idCashier = @idCashier,
                        idCourier = @idCourier,
                        idShop = @idShop,
                        idCustomer = @idCustomer,
                        shippingCost = @shippingCost,
                        saleDiscount = @saleDiscount,
                        subTotal = @subTotal,
                        total = @total,
                        date = GETDATE()
                    WHERE idSale = @idSale
                    PRINT('Sale updated.')
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