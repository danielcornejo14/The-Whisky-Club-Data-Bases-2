CREATE OR ALTER PROCEDURE selectLeastPopularWhiskeys
WITH ENCRYPTION
AS
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
    ORDER BY COUNT(WhiskeyXSale.idWhiskey)
END