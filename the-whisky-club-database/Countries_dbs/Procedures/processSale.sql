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
        DECLARE @longitude varchar(max)
        SET @longitude = (SELECT lat
                         FROM OPENJSON(@json)
                         WITH (
                         lat varchar(max) '$.location.lat'
                         ))
        DECLARE @customerLocation geometry
        IF @length IS NULL AND @longitude IS NULL
        BEGIN
            SET @customerLocation = (SELECT location FROM Customer WHERE idCustomer = @idCustomer)
        END
        ELSE
        BEGIN
            SET @customerLocation = geometry::STPointFromText('POINT (' + @length + ' ' + @longitude + ')', 0)
        END
        --------------------------------------
        --SELECT the closest shop for the customer
        DECLARE @idShop int
        SET @idShop = ( SELECT TOP (1) idShop
                        FROM Shop
                        ORDER BY @customerLocation.STDistance(Shop.location))
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
        -------------------------------------------------------------------
        DECLARE @idSubscription int
        SET @idSubscription = (SELECT idSubscription FROM Customer WHERE idCustomer = @idCustomer)
        DECLARE @shippingDiscount float
        DECLARE @shoppingDiscount float
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
        --Select the distance between the customer and the closest shop.
        DECLARE @distance float
        SET @distance = (SELECT @customerLocation.STDistance(Shop.location)
                         FROM Shop
                         WHERE idShop = @idShop)
        --------------------------------------
        --The shipping cost is $0.5 per Kilometer
        DECLARE @shippingCost money
        SET @shippingCost = (@distance * 0.5)
        --The shipping discount is applied in the shipping cost.
        SET @shippingCost = (@shippingCost - (@shippingDiscount * @shippingCost))
        --Calculate the subtotal from the whiskeys cost.
        DECLARE @subTotal money --The subtotal is the sum of every whiskey price.
        SET @subTotal = (SELECT sum(Whiskey.price)
                         FROM #WhiskeysSelected
                         INNER JOIN Whiskey ON #WhiskeysSelected.idWhiskey = Whiskey.idWhiskey)
        --------------------------------------
        --The sale discount is calculated.
        DECLARE @saleDiscount money
        SET @saleDiscount = (@subTotal * @shoppingDiscount)
        --------------------------------------
        --The total is calculated.
        DECLARE @total money
        SET @total = (@subTotal - @saleDiscount + @shippingCost)
        --------------------------------------
        DECLARE @idCurrency int
        SET @idCurrency = (SELECT DISTINCT Country.idCurrency
                           FROM Shop
                           INNER JOIN Country ON Shop.idCountry = Country.idCountry)
        --------------------------------------------------------------------------
        IF @idCurrency = 1--It is Euro
        BEGIN
            SET @shippingCost = 0.95 * @shippingCost
            SET @saleDiscount = 0.95 * @saleDiscount
            SET @subTotal = 0.95 * @subTotal
            SET @total = 0.95 * @total
        END
        ELSE IF @idCurrency = 3 --It is pound
        BEGIN
            SET @shippingCost = 0.82 * @shippingCost
            SET @saleDiscount = 0.82 * @saleDiscount
            SET @subTotal = 0.82 * @subTotal
            SET @total = 0.82 * @total
        END
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
                --A whiskey is given to the customer for free every ten sales, only for subscription 4.
                IF (SELECT COUNT(idSale) FROM Sale WHERE idCustomer = @idCustomer) % 10 = 0 AND @idSubscription = 4
                BEGIN
                    DECLARE @idRandomWhiskey int
                    SET @idRandomWhiskey = (SELECT TOP (1) idWhiskey FROM WhiskeyXShop ORDER BY NEWID())
                    INSERT INTO WhiskeyXSale(idSale, idWhiskey, quantity)
                    VALUES (@idSale, @idRandomWhiskey , 1)
                    --Decrease whiskey current stock
                    UPDATE WhiskeyXShop
                    SET currentStock = currentStock - 1
                    WHERE idWhiskey = @idRandomWhiskey AND
                          idShop = @idShop
                END
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
                    IF (SELECT currentStock
                        FROM WhiskeyXShop
                        WHERE idWhiskey = @currentIdWhiskey AND
                              idShop = @idShop) = 0
                    BEGIN
                        UPDATE WhiskeyXShop
                        SET availability = 0
                        WHERE idWhiskey = @currentIdWhiskey AND
                              idShop = @idShop
                    END
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