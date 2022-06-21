CREATE OR ALTER PROCEDURE selectWhiskeyAdmin
WITH ENCRYPTION
AS
BEGIN
    SELECT idWhiskey, idSupplier,
           idPresentation, idWhiskeyType,
           brand, price, alcoholContent,
           productionDate, dueDate,
           millilitersQuantity, whiskeyAging,
           special, status
    FROM Whiskey
END