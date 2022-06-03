CREATE TRIGGER trUpdateCountry
ON Country
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Country
    SET idCurrency = inserted.idCurrency,
        name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Country.idCountry = inserted.idCountry
    UPDATE Scotland_db.dbo.Country
    SET idCurrency = inserted.idCurrency,
        name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Country.idCountry = inserted.idCountry
    UPDATE Ireland_db.dbo.Country
    SET idCurrency = inserted.idCurrency,
        name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Country.idCountry = inserted.idCountry
END
