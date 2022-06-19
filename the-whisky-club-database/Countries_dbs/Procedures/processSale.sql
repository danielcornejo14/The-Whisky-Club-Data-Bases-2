CREATE OR ALTER PROCEDURE processSale @json varchar(max)
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
    IF @json IS NOT NULL
    BEGIN
        ----------------------------------------------------------------------------
        --The customer id is gotten from the username.
        DECLARE @username varchar(64)
        SET @username = (SELECT username
                         FROM OPENJSON(@json)
                         WITH (
                            username varchar(64) '$.username'
                         ))
        DECLARE @idCustomer int
        SET @idCustomer = (SELECT idCustomer FROM Customer WHERE userName = @username)
        -----------------------------------------------------------------------------
        --Select a random cashier (Interval between >= 1 and <=10)
        DECLARE @idCashier int
        SET @idCashier = (SELECT TOP (1) idEmployee FROM Employee ORDER BY NEWID())
        -------------------------------------------------------------------------------
        --Select a random courier (Interval between >= 1 and <=10)
        DECLARE @idCourier int
        SET @idCourier = (SELECT TOP (1) idEmployee FROM Employee ORDER BY NEWID())
        -------------------------------------------------------------------------------
        --Get the payment method id
        DECLARE @paymentMethod int
        SET @paymentMethod = (SELECT idPaymentMethod
                              FROM OPENJSON(@json)
                              WITH (
                                idPaymentMethod int '$.method'
                              ))
        ------------------------------------------------------------------------------
        --Select customer location
        DECLARE @length varchar(max)
        SET @length = (SELECT lng
                       FROM OPENJSON(@json)
                       WITH (
                        lng varchar(max) '$.location.lng'
                      ))
        DECLARE @latitude varchar(max)
        SET @latitude = (SELECT lat
                         FROM OPENJSON(@json)
                         WITH (
                         lat varchar(max) '$.location.lat'
                        ))
        DECLARE @customerLocation geometry
        IF @length IS NULL AND @latitude IS NULL
        BEGIN
            SET @customerLocation = (SELECT location FROM Customer WHERE idCustomer = @idCustomer)
        END
        ELSE
        BEGIN
            SET @customerLocation = geometry::STPointFromText('POINT (' + @length + ' ' + @latitude + ')', 0)
        END
        --------------------------------------
        --SELECT the closest shop for the customer
        DECLARE @idShop int
        SET @idShop = ( SELECT TOP (1) idShop
                        FROM Shop
                        ORDER BY @customerLocation.STDistance(Shop.location))
        --------------------------------------
        --Select shipping cost
        DECLARE @shippingCost money
        SET @shippingCost = (SELECT shippingCost FROM ##SaleInfo)
        --------------------------------------
        --Select saleDiscount cost
        DECLARE @saleDiscount money
        SET @saleDiscount = (SELECT saleDiscount FROM ##SaleInfo)
        --------------------------------------
        --Select subTotal cost
        DECLARE @subTotal money
        SET @subTotal = (SELECT subTotal FROM ##SaleInfo)
        --------------------------------------
        --Select total cost
        DECLARE @total money
        SET @total = (SELECT total FROM ##SaleInfo)
        --------------------------------------
        DROP TABLE ##SaleInfo
        --------------------------------------
        --The whiskeys selected ids are stored in a temporal table.
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
        --------------------------------------
        BEGIN TRANSACTION
            BEGIN TRY
                --Insert the sale
                INSERT INTO Sale(idPaymentMethod, idCashier, idCourier,
                                 idShop, idCustomer, shippingCost,
                                 saleDiscount, subTotal, total,
                                 date)
                VALUES(@paymentMethod, @idCashier, @idCourier,
                       @idShop, @idCustomer, @shippingCost,
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
                          idShop = @idShop
                    -----------------------------------------------------
                    FETCH NEXT FROM whiskeysCursor INTO @currentIdWhiskey
                END
                CLOSE whiskeysCursor
                DEALLOCATE whiskeysCursor
                ---------------------------------------------------------
                DROP TABLE #WhiskeysSelected
                PRINT('Sale registered.')
                COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO