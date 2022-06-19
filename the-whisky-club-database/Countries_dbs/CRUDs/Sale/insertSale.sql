CREATE OR ALTER PROCEDURE insertSale @pIdShop int, @pIdPaymentMethod int,
                                     @pIdCashier int, @pIdCourier int,
                                     @pIdCustomer int, @pShippingCost money,
                                     @json varchar(max)
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

    IF @pIdShop IS NOT NULL AND @pIdPaymentMethod IS NOT NULL
        AND @pIdCashier IS NOT NULL AND @pIdCourier IS NOT NULL
        AND @pIdCustomer IS NOT NULL AND @pShippingCost IS NOT NULL
        AND @json IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idShop) FROM Shop WHERE idShop = @pIdShop
                AND status = 1) > 0
            AND (SELECT COUNT(idPaymentMethod) FROM PaymentMethod WHERE idPaymentMethod = @pIdPaymentMethod
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @pIdCashier
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = @pIdCourier
                AND status = 1) > 0
            AND (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @pIdCustomer
                AND status = 1) > 0
            AND @pShippingCost >= 0)
        BEGIN
            DECLARE @idSubscription int
            SET @idSubscription = (SELECT idSubscription FROM Customer WHERE idCustomer = @pIdCustomer)
            DECLARE @shippingDiscount float
            DECLARE @shoppingDiscount float
            --------------------------------------------------------------------------
            --The shipping and shopping discount is set .
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
            --------------------------------------------------------------------------
            --The final shopping cost is set.
            SET @pShippingCost = (@pShippingCost - (@shippingDiscount * @pShippingCost))
            --------------------------------------------------------------------------
            --The whiskeys ids are extracted from the json.
            CREATE TABLE #WhiskeysSelected(
                idWhiskey int
            )
            INSERT INTO #WhiskeysSelected
            SELECT idWhiskey
            FROM OPENJSON(@json)
                WITH (
                    selectedWhiskeys nvarchar(MAX) '$.cart' AS JSON
                )
                CROSS APPLY OPENJSON(selectedWhiskeys)
                    WITH (
                        idWhiskey int '$'
                    )
            --------------------------------------------------------------------------
            --Calculate the subtotal from the whiskeys cost.
            DECLARE @subTotal money --The subtotal is the sum of every whiskey price.
            SET @subTotal = (SELECT SUM(price)
                             FROM Whiskey
                             WHERE idWhiskey
                             IN (SELECT idWhiskey
                                 FROM #WhiskeysSelected)
                             )
            -------------------------------------------------------------------------
            --The sale discount is calculated.
            DECLARE @saleDiscount money
            SET @saleDiscount = (@subTotal * @shoppingDiscount)
            -------------------------------------------------------------------------
            --The total is calculated.
            DECLARE @total money
            SET @total = (@subTotal - @saleDiscount + @pShippingCost)
            --------------------------------------------------------------------------
             BEGIN TRANSACTION
                BEGIN TRY
                    --Insert the sale
                    INSERT INTO Sale(idPaymentMethod, idCashier, idCourier,
                                     idShop, idCustomer, shippingCost,
                                     saleDiscount, subTotal, total,
                                     date)
                    VALUES(@pIdPaymentMethod, @pIdCashier, @pIdCourier,
                           @pIdShop, @pIdCustomer, @pShippingCost,
                           @saleDiscount, @subTotal, @total,
                           GETDATE())
                    --------------------------------------------------------------------------
                    --Select the id sale
                    DECLARE @idSale int
                    SET @idSale = SCOPE_IDENTITY()
                    --------------------------------------------------------------------------
                    --Cursor for sold whiskeys
                    DECLARE @currentIdWhiskey int
                    DECLARE whiskeysCursor CURSOR FOR SELECT
                    idWhiskey FROM #WhiskeysSelected
                    OPEN whiskeysCursor
                    FETCH NEXT FROM whiskeysCursor INTO @currentIdWhiskey
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        INSERT INTO WhiskeyXSale(idSale, idWhiskey, quantity)
                        VALUES (@idSale, @currentIdWhiskey, 1)
                        -----------------------------------------------------
                        --Decrease whiskey current stock
                        UPDATE WhiskeyXShop
                        SET currentStock = currentStock - 1
                        WHERE idWhiskey = @currentIdWhiskey AND
                              idShop = @pIdShop
                        -----------------------------------------------------
                        FETCH NEXT FROM whiskeysCursor INTO @currentIdWhiskey
                    END
                    CLOSE whiskeysCursor
                    DEALLOCATE whiskeysCursor
                    --------------------------------------------------------------------------
                    DROP TABLE #WhiskeysSelected
                    PRINT('Sale inserted.')
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

EXEC insertSale @pIdShop = 1, @pIdPaymentMethod = 1, @pIdCashier = 1, @pIdCourier = 2,
                @pIdCustomer = 1, @pShippingCost = 0.5, @json = N'{"cart": [1]}'