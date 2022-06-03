CREATE TRIGGER trUpdatePaymentMethod
ON PaymentMethod
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.PaymentMethod
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.PaymentMethod.idPaymentMethod = inserted.idPaymentMethod
    UPDATE Scotland_db.dbo.PaymentMethod
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.PaymentMethod.idPaymentMethod = inserted.idPaymentMethod
    UPDATE Ireland_db.dbo.PaymentMethod
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.PaymentMethod.idPaymentMethod = inserted.idPaymentMethod
END