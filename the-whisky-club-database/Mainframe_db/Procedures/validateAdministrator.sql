CREATE FUNCTION validateAdministrator (
    @idAdministrator int,
    @password varchar(64)
)
RETURNS varchar(2)
AS
BEGIN
    IF (SELECT COUNT(idAdministrator) FROM Administrator WHERE idAdministrator = @idAdministrator
        AND status = 1 AND password = HASHBYTES('MD4', @password)) > 0
    BEGIN
        return '01' --The idAdmin and password are correct.
    END
    return '00' --The idAdmin or password are incorrect.
END
GO