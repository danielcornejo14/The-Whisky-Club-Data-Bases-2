CREATE PROCEDURE readAdministrator @idAdministrator int
WITH ENCRYPTION
AS
BEGIN
    IF @idAdministrator IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idAdministrator) FROM Administrator WHERE idAdministrator = @idAdministrator
            AND status = 1) > 0
        BEGIN
            SELECT idAdministrator, emailAddress, name, userName, password, lastName1, lastName2, status
            FROM Administrator
            WHERE idAdministrator = @idAdministrator
        END
        ELSE
        BEGIN
            RAISERROR('The Administrator id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO