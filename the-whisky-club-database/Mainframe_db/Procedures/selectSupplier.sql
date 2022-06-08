CREATE PROCEDURE selectSupplier
WITH ENCRYPTION
AS
BEGIN
    SELECT idSupplier, name, emailAddress, status
    FROM Supplier
END