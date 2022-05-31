CREATE PROCEDURE readCurrency @idCurrency int
WITH ENCRYPTION
AS
BEGIN
    IF @idCurrency IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCurrency) FROM Currency WHERE idCurrency = @idCurrency
             AND status = 1) > 0
        BEGIN
            SELECT idCurrency, name, status
            FROM Currency
            WHERE idCurrency = @idCurrency
        END
        ELSE
        BEGIN
            RAISERROR('The currency id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO