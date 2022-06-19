CREATE OR ALTER PROCEDURE selectWhiskeysByType @idWhiskeyType int, @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyType IS NOT NULL AND @idShop IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType) > 0
            AND (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop) > 0)
        BEGIN
            SELECT Whiskey.idWhiskey, S.name AS Supplier,
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
            WHERE WXS.status = 1
                  AND WXS.currentStock > 0
                  AND Whiskey.idWhiskeyType = @idWhiskeyType
                  AND WXS.idShop = @idShop
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