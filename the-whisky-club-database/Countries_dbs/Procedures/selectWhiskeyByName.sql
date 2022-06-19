CREATE OR ALTER PROCEDURE selectWhiskeysByName @brand varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @brand IS NOT NULL
    BEGIN
        IF (SELECT COUNT(brand) FROM Whiskey WHERE brand = @brand) > 0
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