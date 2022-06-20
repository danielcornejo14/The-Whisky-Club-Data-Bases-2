CREATE OR ALTER PROCEDURE selectWhiskeysByDistance @actualLocation geometry
WITH ENCRYPTION
AS
BEGIN
    IF @actualLocation IS NOT NULL
    BEGIN
        SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
               Whiskey.idPresentation, Whiskey.idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, Shop.location.STDistance(@actualLocation) AS Distance,
               Shop.idShop, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        INNER JOIN Shop ON WXS.idShop = Shop.idShop
        WHERE WXS.status = 1 AND WXS.currentStock > 0
        ORDER BY Shop.location.STDistance(@actualLocation)
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END