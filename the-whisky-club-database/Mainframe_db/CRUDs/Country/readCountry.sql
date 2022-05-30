CREATE PROCEDURE readCountry @idCountry int
WITH ENCRYPTION
AS
BEGIN
    IF @idCountry IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCountry) FROM Country WHERE idCountry = @idCountry
            AND status = 1) > 0
        BEGIN
            SELECT idCountry, idCurrency, name, status
            FROM Country
            WHERE idCountry = @idCountry
        END
        ELSE
        BEGIN
            RAISERROR('The Country id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO