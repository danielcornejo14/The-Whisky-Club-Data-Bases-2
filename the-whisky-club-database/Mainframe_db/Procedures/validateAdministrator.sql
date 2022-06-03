CREATE PROCEDURE validateAdministrator
    @userName varchar(64),
    @password varchar(64)
AS
BEGIN
    IF (SELECT COUNT(idAdministrator) FROM Administrator WHERE userName = @userName
        AND status = 1 AND password = HASHBYTES('MD4', @password)) > 0
    BEGIN
        select '01' as message --The idAdmin and password are correct.
    END
    select '00' as message --The idAdmin or password are incorrect.
END
GO