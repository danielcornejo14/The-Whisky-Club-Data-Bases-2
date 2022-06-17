CREATE PROCEDURE readWhiskeyXSale @idWhiskeyXSale int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyXSale IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyXSale) FROM WhiskeyXSale WHERE idWhiskeyXSale = @idWhiskeyXSale
            AND status = 1) > 0
        BEGIN
            SELECT idWhiskeyXSale, idSale, idWhiskey, quantity, status
            FROM WhiskeyXSale
            WHERE idWhiskeyXSale = @idWhiskeyXSale
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyXSale id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO