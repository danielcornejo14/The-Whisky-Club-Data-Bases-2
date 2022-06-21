CREATE OR ALTER PROCEDURE selectWhiskey @userName varchar(64)
WITH ENCRYPTION
AS
BEGIN
    DECLARE @idSubscription int
    SET @idSubscription = (SELECT idSubscription FROM Customer WHERE userName = @userName)
    IF @idSubscription = 3 OR @idSubscription = 4
    BEGIN
        SELECT idWhiskey, idSupplier,
               idPresentation, idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, status
        FROM Whiskey
        WHERE Whiskey.special = 1
    END
    ELSE
    BEGIN
        SELECT idWhiskey, idSupplier,
               idPresentation, idWhiskeyType,
               brand, price, alcoholContent,
               productionDate, dueDate,
               millilitersQuantity, whiskeyAging,
               special, status
        FROM Whiskey
        WHERE Whiskey.special = 0
    END
END