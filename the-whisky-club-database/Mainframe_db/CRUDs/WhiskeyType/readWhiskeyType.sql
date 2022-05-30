CREATE PROCEDURE readWhiskeyType @idWhiskeyType int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyType IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType
             AND status = 1) > 0
        BEGIN
            SELECT idWhiskeyType, name, status
            FROM WhiskeyType
            WHERE idWhiskeyType = @idWhiskeyType
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyType id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO