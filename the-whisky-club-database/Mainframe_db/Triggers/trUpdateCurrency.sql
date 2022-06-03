CREATE TRIGGER trUpdateCurrency
ON Currency
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Currency
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Currency.idCurrency = inserted.idCurrency
    UPDATE Scotland_db.dbo.Currency
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Currency.idCurrency = inserted.idCurrency
    UPDATE Ireland_db.dbo.Currency
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Currency.idCurrency = inserted.idCurrency
END