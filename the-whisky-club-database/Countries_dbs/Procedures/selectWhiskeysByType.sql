CREATE OR ALTER PROCEDURE selectWhiskeysByType @idWhiskeyType int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyType IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType) > 0
        BEGIN
            SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
                   Whiskey.idPresentation, Whiskey.idWhiskeyType,
                   brand, price, alcoholContent,
                   productionDate, dueDate,
                   millilitersQuantity, whiskeyAging,
                   special, Whiskey.status
            FROM Whiskey
            INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
            INNER JOIN Supplier S ON Whiskey.idSupplier = S.idSupplier
            INNER JOIN Presentation P ON P.idPresentation = Whiskey.idPresentation
            INNER JOIN WhiskeyType WT ON Whiskey.idWhiskeyType = WT.idWhiskeyType
            WHERE WXS.status = 1 AND Whiskey.idWhiskeyType = @idWhiskeyType
                  AND WXS.currentStock > 0
        END
        ELSE
        BEGIN
            RAISERROR('The ids must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END