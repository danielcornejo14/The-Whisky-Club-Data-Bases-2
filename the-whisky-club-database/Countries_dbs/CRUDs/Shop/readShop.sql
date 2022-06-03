CREATE PROCEDURE readShop @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
            AND status = 1) > 0
        BEGIN
            SELECT idShop, idCountry, idAddress, name, phone, location, status
            FROM Shop
            WHERE idShop = @idShop
        END
        ELSE
        BEGIN
            RAISERROR('The Shop id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO