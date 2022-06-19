CREATE OR ALTER PROCEDURE selectWhiskeysByPrice @minPrice money, @maxPrice money,
                                                @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @minPrice IS NOT NULL AND @idShop IS NOT NULL
        AND @maxPrice IS NOT NULL
    BEGIN
        IF (@maxPrice > 0
            AND (@minPrice < @maxPrice)
            AND (@minPrice > 0)
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
                  AND (Whiskey.price BETWEEN @minPrice AND @maxPrice)
                  AND WXS.idShop = @idShop
        END
        ELSE
        BEGIN
            RAISERROR('The id must exist, and the min and max price must be greater than 0.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END