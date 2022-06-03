CREATE TRIGGER trInsertShopScotland
ON Shop
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO UnitedStates_db.dbo.Shop(idCountry, name, phone, location)
	SELECT inserted.idCountry, inserted.name, inserted.phone,
	       inserted.location
	FROM inserted
    INSERT INTO Ireland_db.dbo.Shop(idCountry, name, phone, location)
	SELECT inserted.idCountry, inserted.name, inserted.phone,
	       inserted.location
	FROM inserted
END