CREATE OR ALTER PROCEDURE readWhiskey @idWhiskey int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskey IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey AND
             status = 1) > 0
        BEGIN
            SELECT idWhiskey, idSupplier, idPresentation,
                   idWhiskeyType, brand, price, alcoholContent,
                   productionDate, dueDate,
                   millilitersQuantity, whiskeyAging,
                   special, status
            FROM Whiskey
            WHERE idWhiskey = @idWhiskey
        END
        ELSE
        BEGIN
            RAISERROR('The Whiskey id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO