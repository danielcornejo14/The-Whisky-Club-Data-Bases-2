CREATE OR ALTER PROCEDURE selectWhiskeysByAvailability @availability int

WITH ENCRYPTION
AS
BEGIN
    IF @availability IS NOT NULL
    BEGIN
        IF (@availability = 0 OR @availability = 1)
        BEGIN
            SELECT Whiskey.idWhiskey, Whiskey.idSupplier,
                   Whiskey.idPresentation, Whiskey.idWhiskeyType,
                   brand, price, alcoholContent,
                   productionDate, dueDate,
                   millilitersQuantity, whiskeyAging,
                   special, Whiskey.status
            FROM Whiskey
            INNER JOIN WhiskeyXShop WXS ON Whiskey.idWhiskey = WXS.idWhiskey
            WHERE WXS.status = 1 AND WXS.availability = @availability AND
                  WXS.currentStock > 0
        END
        ELSE
        BEGIN
            RAISERROR('The availability must be 0 or 1.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END