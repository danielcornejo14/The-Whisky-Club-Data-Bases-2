CREATE PROCEDURE validateCustomer
    @userName varchar(64),
    @password varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF (SELECT COUNT(idCustomer) FROM CustomerAccount WHERE userName = @userName
        AND status = 1 AND password = HASHBYTES('SHA2_256', @password)) > 0
    BEGIN
        select '00' as message --The idAdmin or password are correct.
    END
    ELSE
    BEGIN
        select '01' as message --The idAdmin and password are incorrect.
    END
END
GO