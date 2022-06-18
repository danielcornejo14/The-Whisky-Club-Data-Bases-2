CREATE PROCEDURE selectSaleInfo @json varchar(max)
WITH ENCRYPTION
AS
BEGIN
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
        --Select the distance between the customer and the closest shop.
        DECLARE @distance float
        SET @distance = (SELECT TOP (1) @customerLocation.STDistance(Shop.location)
                         FROM Shop
                         ORDER BY @customerLocation.STDistance(Shop.location))
        --------------------------------------
        --The shipping cost is $0.5 per Kilometer
        DECLARE @shippingCost money
        SET @shippingCost = (@distance * 0.5)
        --The shipping discount is applied in the shipping cost.
        SET @shippingCost = (@shippingCost - (@shippingDiscount * @shippingCost))
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
        --Calculate the subtotal from the whiskeys cost.
        DECLARE @subTotal money --The subtotal is the sum of every whiskey price.
        SET @subTotal = (SELECT SUM(price)
                         FROM Whiskey
                         WHERE idWhiskey
                         IN (SELECT idWhiskey
                             FROM #WhiskeysSelected)
                         )
        --------------------------------------
        --The sale discount is calculated.
        DECLARE @saleDiscount money
        SET @saleDiscount = (@subTotal * @shoppingDiscount)
        --------------------------------------
        --The total is calculated.
        DECLARE @total money
        SET @total = (@subTotal - @saleDiscount + @shippingCost)
        --------------------------------------
        --Create temporal table Sale info
        CREATE TABLE ##SaleInfo(
            shippingCost money,
            saleDiscount money,
            subTotal money,
            total money
        )
        --Insert values in Sale info
        INSERT INTO ##SaleInfo(shippingCost, saleDiscount, subTotal, total)
        VALUES (@shippingCost, @saleDiscount, @subTotal, @total)
        --------------------------------------
        SELECT @subTotal, @saleDiscount, @shippingCost, @total
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END