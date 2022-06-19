CREATE OR ALTER PROCEDURE selectWhiskeysByDistance @actualLocation geometry
WITH ENCRYPTION
AS
BEGIN
    IF @actualLocation IS NOT NULL
    BEGIN
        SELECT Shop.location.STDistance(@actualLocation) AS Distance,
               Whiskey.idWhiskey, S.name AS Supplier,
               Shop.name AS ShopName,
               P.description AS Presentation,
               WT.name AS WhiskeyType, brand, price,
               alcoholContent, productionDate, dueDate,
               availability, millilitersQuantity,
               whiskeyAging, special, Whiskey.status
        FROM Whiskey
        INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
        INNER JOIN Supplier S ON Whiskey.idSupplier = S.idSupplier
        INNER JOIN Presentation P ON P.idPresentation = Whiskey.idPresentation
        INNER JOIN WhiskeyType WT ON Whiskey.idWhiskeyType = WT.idWhiskeyType
        INNER JOIN Shop ON WXS.idShop = Shop.idShop
        WHERE WXS.status = 1 AND WXS.currentStock > 0
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END