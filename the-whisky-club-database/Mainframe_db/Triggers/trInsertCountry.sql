CREATE TRIGGER trInsertCountry
ON Country
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Country(idCurrency, name)
	SELECT inserted.idCurrency, inserted.name
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.Country(idCurrency, name)
	SELECT inserted.idCurrency, inserted.name
	FROM inserted
    INSERT INTO Scotland_db.dbo.Country(idCurrency, name)
	SELECT inserted.idCurrency, inserted.name
	FROM inserted
END