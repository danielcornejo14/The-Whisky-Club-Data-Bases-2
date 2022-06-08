CREATE PROCEDURE selectWhiskey
WITH ENCRYPTION
AS
BEGIN
    SELECT idWhiskey, idSupplier, idPresentation,
           idCurrency, idWhiskeyType, brand, price,
           alcoholContent, productionDate, dueDate,
           availability, millilitersQuantity, whiskeyAging,
           special, status
    FROM Whiskey
END