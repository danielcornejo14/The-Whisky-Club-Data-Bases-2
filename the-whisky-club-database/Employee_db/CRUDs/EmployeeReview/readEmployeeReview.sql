CREATE PROCEDURE readWhiskeyXShop @idWhiskeyXShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyXShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyXShop) FROM WhiskeyXShop WHERE idWhiskeyXShop = @idWhiskeyXShop
            AND status = 1) > 0
        BEGIN
            SELECT idWhiskeyXShop, idShop, idWhiskey, currentStock, status
            FROM WhiskeyXShop
            WHERE idWhiskeyXShop = @idWhiskeyXShop
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyXShop id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO