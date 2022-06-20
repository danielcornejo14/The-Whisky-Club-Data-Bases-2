CREATE OR ALTER PROCEDURE selectWhiskeysCountry

WITH ENCRYPTION
AS
BEGIN
    SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
           Whiskey.idPresentation, Whiskey.idWhiskeyType,
           brand, price, alcoholContent,
           productionDate, dueDate,
           millilitersQuantity, whiskeyAging,
           special, Whiskey.status
    FROM Whiskey
    INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
    WHERE WXS.status = 1 AND WXS.currentStock > 0
END