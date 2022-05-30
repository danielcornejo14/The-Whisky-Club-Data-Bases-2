CREATE PROCEDURE readAddress @idAddress int
WITH ENCRYPTION
AS
BEGIN
    IF @idAddress IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idAddress) FROM Address WHERE idAddress = @idAddress
            AND status = 1) > 0
        BEGIN
            SELECT idAddress, idCity, status
            FROM Address
            WHERE idAddress = @idAddress
        END
        ELSE
        BEGIN
            RAISERROR('The address id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO