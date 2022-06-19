CREATE PROCEDURE selectWhiskey
WITH ENCRYPTION
AS
BEGIN
    SELECT idWhiskey, S.name AS Supplier, P.description AS Presentation,
           WT.name AS WhiskeyType, brand, price,
           alcoholContent, productionDate, dueDate,
           availability, millilitersQuantity, whiskeyAging,
           special, Whiskey.status
    FROM Whiskey
    INNER JOIN WhiskeyType WT ON Whiskey.idWhiskeyType = WT.idWhiskeyType
    INNER JOIN Supplier S ON Whiskey.idSupplier = S.idSupplier
    INNER JOIN Presentation P ON Whiskey.idPresentation = P.idPresentation
END