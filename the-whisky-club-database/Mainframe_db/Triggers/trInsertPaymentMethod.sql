CREATE TRIGGER trInsertPaymentMethod
ON PaymentMethod
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.PaymentMethod(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.PaymentMethod(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO Scotland_db.dbo.PaymentMethod(name)
	SELECT inserted.name
	FROM inserted
END