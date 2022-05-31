CREATE PROCEDURE readCounty @idCounty int
WITH ENCRYPTION
AS
BEGIN
    IF @idCounty IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCounty) FROM County WHERE idCounty = @idCounty
            AND status = 1) > 0
        BEGIN
            SELECT idCounty, idState, name, status
            FROM County
            WHERE idCounty = @idCounty
        END
        ELSE
        BEGIN
            RAISERROR('The county id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO