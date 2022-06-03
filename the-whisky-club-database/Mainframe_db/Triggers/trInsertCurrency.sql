CREATE TRIGGER trInsertCurrency
ON Currency
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Currency(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.Currency(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO Scotland_db.dbo.Currency(name)
	SELECT inserted.name
	FROM inserted
END