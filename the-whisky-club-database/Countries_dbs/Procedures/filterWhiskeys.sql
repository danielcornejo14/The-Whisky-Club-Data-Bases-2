CREATE PROCEDURE filterWhiskeys @userName varchar(64), @idWhiskeyType int,
                                @brand varchar(64), @maxPrice money, @availability int,
                                @order int, @popularity bit
WITH ENCRYPTION
AS
BEGIN
    DECLARE @location geometry
    IF @availability = 1
    BEGIN
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        WHERE WXS.status = 1 AND WXS.availability = @availability AND
              WXS.currentStock > 0
    END
    ELSE IF @userName != '' AND @order = 0
    BEGIN
        SET @location = (SELECT location FROM Customer WHERE userName = @userName)
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Shop.location.STDistance(@location) AS Distance,
               Shop.idShop, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        INNER JOIN Shop ON WXS.idShop = Shop.idShop
        WHERE WXS.status = 1 AND WXS.currentStock > 0
        ORDER BY Shop.location.STDistance(@location) DESC
    END
    ELSE IF @userName != '' AND @order = 1
    BEGIN
        SET @location = (SELECT location FROM Customer WHERE userName = @userName)
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Shop.location.STDistance(@location) AS Distance,
               Shop.idShop, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        INNER JOIN Shop ON WXS.idShop = Shop.idShop
        WHERE WXS.status = 1 AND WXS.currentStock > 0
        ORDER BY Shop.location.STDistance(@location)
    END
    ELSE IF @brand != ''
    BEGIN
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        WHERE WXS.status = 1 AND Whiskey.brand = @brand AND WXS.currentStock > 0
    END
    ELSE IF @maxPrice IS NOT NULL
    BEGIN
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        WHERE WXS.status = 1 AND (Whiskey.price <= @maxPrice)
              AND WXS.currentStock > 0
    END
    ELSE IF @idWhiskeyType IS NOT NULL
    BEGIN
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        WHERE WXS.status = 1 AND Whiskey.idWhiskeyType = @idWhiskeyType
              AND WXS.currentStock > 0
    END
    ELSE IF @popularity = 1
    BEGIN
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Whiskey.status
        FROM WhiskeyXSale
        INNER JOIN Whiskey ON WhiskeyXSale.idWhiskey = Whiskey.idWhiskey
        INNER JOIN Sale ON Sale.idSale = WhiskeyXSale.idSale
        INNER JOIN WhiskeyXShop ON Whiskey.idWhiskey = WhiskeyXShop.idWhiskey
        WHERE WhiskeyXSale.status = 1 AND WhiskeyXShop.status = 1
              AND WhiskeyXShop.currentStock > 0
        GROUP BY Whiskey.idWhiskey, Whiskey.idSupplier,
                   Whiskey.idPresentation, Whiskey.idWhiskeyType,
                   brand, price, alcoholContent,
                   productionDate, dueDate,
                   millilitersQuantity, whiskeyAging,
                   special, Whiskey.status
        ORDER BY COUNT(WhiskeyXSale.idWhiskey) DESC
    END
END