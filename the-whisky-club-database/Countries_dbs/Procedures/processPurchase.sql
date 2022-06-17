CREATE PROCEDURE processPurchase @json varchar(max)
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
        -------------------------------------------------------------------------------
        --Select a random employee (Interval between >= 1 and <=10)
        DECLARE @idCashier int
        SET @idCashier = (SELECT FLOOR(RAND()*(10-1)+1))
        -------------------------------------------------------------------------------
        --Select a random employee (Interval between >= 1 and <=10)
        DECLARE @idCourier int
        SET @idCourier = (SELECT FLOOR(RAND()*(10-1)+1))
        -------------------------------------------------------------------------------
        --Get the payment method id
        DECLARE @paymentMethod int
        SET @paymentMethod = (SELECT idPaymentMethod
                              FROM OPENJSON(@json)
                              WITH (
                                idPaymentMethod int '$.method'
                              ))
        -------------------------------------------------------------------------------
        --Get the customer id from the user name
        DECLARE @idCustomer int
        SET @idCustomer = (SELECT idCustomer FROM Customer WHERE userName = @username)
        -------------------------------------------------------------------------------
        DECLARE @whiskeyPrice money
        SET @whiskeyPrice = (SELECT price FROM Whiskey WHERE idWhiskey = @pIdWhiskey)
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
        SET @customerLocation = geometry::STPointFromText('POINT (' + @length + ' ' + @latitude + ')', 0)
        --------------------------------------
        --SELECT the closest shop for the customer
        DECLARE @idShop int
        SET @idShop = ( SELECT TOP (1) idShop
                        FROM Shop
                        ORDER BY @customerLocation.STDistance(Shop.location))
        --------------------------------------
        --Select the distance between the customer and the closest shop.
        DECLARE @distance float
        SET @distance = (SELECT TOP (1) @customerLocation.STDistance(Shop.location)
                         FROM Shop
                         ORDER BY @customerLocation.STDistance(Shop.location))
        --The shipping cost is $0.5 per Kilometer
        DECLARE @pShippingCost money
        SET @pShippingCost = (@distance * 0.5)
        --------------------------------------
        SET @pShippingCostFinal = (@pShippingCost - (@shippingDiscount * @pShippingCost))

        --Meter el subtotal en un cursor

        SET @subTotal = ((@whiskeyPrice * @pQuantity) + @pShippingCostFinal)
        SET @total = (@subTotal - (@subTotal * @shoppingDiscount))
        BEGIN TRANSACTION
            BEGIN TRY
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
                DROP TABLE #WhiskeysSelected
                PRINT('Purchase registered.')
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