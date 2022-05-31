CREATE PROCEDURE readCity @idCity int
WITH ENCRYPTION
AS
BEGIN
    IF @idCity IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCity) FROM City WHERE idCity = @idCity AND
             status = 1) > 0
        BEGIN
            SELECT idCity, idCounty, name, status
            FROM City
            WHERE idCity = @idCity
        END
        ELSE
        BEGIN
            RAISERROR('The City id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO