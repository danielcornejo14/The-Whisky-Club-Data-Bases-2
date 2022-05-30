CREATE PROCEDURE readSupplier @idSupplier int
WITH ENCRYPTION
AS
BEGIN
    IF @idSupplier IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idSupplier) FROM Supplier WHERE idSupplier = @idSupplier
             AND status = 1) > 0
        BEGIN
            SELECT idSupplier, name, emailAddress, status
            FROM Supplier
            WHERE idSupplier = @idSupplier
        END
        ELSE
        BEGIN
            RAISERROR('The supplier id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO