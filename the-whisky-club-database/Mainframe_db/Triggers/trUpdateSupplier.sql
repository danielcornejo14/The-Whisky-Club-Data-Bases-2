CREATE TRIGGER trUpdateSupplier
ON Supplier
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Supplier
    SET name = inserted.name,
        emailAddress = inserted.emailAddress,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Supplier.idSupplier = inserted.idSupplier
    UPDATE Scotland_db.dbo.Supplier
    SET name = inserted.name,
        emailAddress = inserted.emailAddress,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Supplier.idSupplier = inserted.idSupplier
    UPDATE Ireland_db.dbo.Supplier
    SET name = inserted.name,
        emailAddress = inserted.emailAddress,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Supplier.idSupplier = inserted.idSupplier
END