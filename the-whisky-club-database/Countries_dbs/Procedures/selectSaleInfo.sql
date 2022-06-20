CREATE OR ALTER PROCEDURE selectSaleInfo @json varchar(max)
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
        DECLARE @stockAvailable int
        DECLARE @currentIdWhiskey int
        DECLARE whiskeysCursor CURSOR FOR SELECT
        idWhiskey FROM #WhiskeysSelected
        OPEN whiskeysCursor
        FETCH NEXT FROM whiskeysCursor INTO @currentIdWhiskey
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF ((SELECT COUNT(idWhiskey) FROM #WhiskeysSelected WHERE idWhiskey = @currentIdWhiskey)
                - (SELECT currentStock FROM WhiskeyXShop WHERE idShop = @idShop AND idWhiskey = @currentIdWhiskey)) > 0
            BEGIN
                SET @stockAvailable = 0
                BREAK
            END
            FETCH NEXT FROM whiskeysCursor INTO @currentIdWhiskey
        END
        CLOSE whiskeysCursor
        DEALLOCATE whiskeysCursor
        --The stock is not sufficient.
        IF @stockAvailable = 0
        BEGIN
            SELECT '00' AS CODE, 'mensaje' AS MESSAGE
        END
        ELSE
        BEGIN
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
            DECLARE @currencyName varchar(64)
            IF @idCurrency = 1--It is Euro
            BEGIN
                SET @shippingCost = 0.95 * @shippingCost
                SET @saleDiscount = 0.95 * @saleDiscount
                SET @subTotal = 0.95 * @subTotal
                SET @total = 0.95 * @total
                SET @currencyName = 'Euro'
            END
            ELSE IF @idCurrency = 3 --It is pound
            BEGIN
                SET @shippingCost = 0.82 * @shippingCost
                SET @saleDiscount = 0.82 * @saleDiscount
                SET @subTotal = 0.82 * @subTotal
                SET @total = 0.82 * @total
                SET @currencyName = 'Pound'
            END
            ELSE
            BEGIN
                SET @currencyName = 'Dollar'
            END
            ---------------------------------
            --Drop temporal table
            DROP TABLE #WhiskeysSelected
            ---------------------------------
            SELECT @currencyName as currenyName,
                   @subTotal as subTotal,
                   @saleDiscount as saleDiscount,
                   @shippingCost as shippingCost,
                   @total as total
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END