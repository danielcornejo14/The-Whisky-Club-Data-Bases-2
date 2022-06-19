CREATE OR ALTER PROCEDURE selectWhiskeysByName @brand varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @brand IS NOT NULL
    BEGIN
        IF (SELECT COUNT(brand) FROM Whiskey WHERE brand = @brand) > 0
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
                  AND Whiskey.brand = @brand
        END
        ELSE
        BEGIN
            RAISERROR('The brand must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END

EXEC selectWhiskeysByName @brand = 'Chivas Regal'