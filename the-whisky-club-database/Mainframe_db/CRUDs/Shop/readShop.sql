CREATE PROCEDURE readShop @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
            AND status = 1) > 0
        BEGIN
            DECLARE @idCountry int
            SET @idCountry = (SELECT(idCountry) FROM Shop WHERE idShop = @idShop)
            IF @idCountry = 1 --1 is for USA.
            BEGIN
                SELECT idShop, idCountry, name, phone, location.STAsText(), status
                FROM Shop
                WHERE idShop = @idShop
            END
            ELSE IF @idCountry = 2 --2 is for Ireland
            BEGIN
                SELECT idShop, idCountry, name, phone, location.STAsText(), status
                FROM Shop
                WHERE idShop = @idShop
            END
            ELSE IF @idCountry = 3 --3 is for Scotland
            BEGIN
                SELECT idShop, idCountry, name, phone, location.STAsText(), status
                FROM Shop
                WHERE idShop = @idShop
            END
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