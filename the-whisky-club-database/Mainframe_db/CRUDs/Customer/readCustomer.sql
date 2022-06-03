CREATE PROCEDURE readCustomer @idCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @idCustomer IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @idCustomer AND
             status = 1) > 0
        BEGIN
            SELECT idCustomer, idSubscription, emailAddress,
                   name, lastName1, lastName2, location,
                   userName, password, status
            FROM Customer
            WHERE idCustomer = @idCustomer
        END
        ELSE
        BEGIN
            RAISERROR('The Customer id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO