CREATE TRIGGER trInsertSupplier
ON Supplier
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Supplier(name, emailAddress)
	SELECT inserted.name, inserted.emailAddress
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.Supplier(name, emailAddress)
	SELECT inserted.name, inserted.emailAddress
	FROM inserted
    INSERT INTO Scotland_db.dbo.Supplier(name, emailAddress)
	SELECT inserted.name, inserted.emailAddress
	FROM inserted
END