CREATE OR ALTER PROCEDURE selectWhiskeysByPrice @minPrice money, @maxPrice money
WITH ENCRYPTION
AS
BEGIN
    IF @minPrice IS NOT NULL AND @maxPrice IS NOT NULL
    BEGIN
        IF (@maxPrice > 0
            AND (@minPrice < @maxPrice)
            AND (@minPrice > 0))
        BEGIN
            SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
                   Whiskey.idPresentation, Whiskey.idWhiskeyType,
                   brand, price, alcoholContent,
                   productionDate, dueDate,
                   millilitersQuantity, whiskeyAging,
                   special, Whiskey.status
            FROM Whiskey
            INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
            WHERE WXS.status = 1 AND (Whiskey.price BETWEEN @minPrice AND @maxPrice)
                  AND WXS.currentStock > 0
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