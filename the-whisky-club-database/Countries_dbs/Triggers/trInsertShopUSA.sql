CREATE TRIGGER trInsertShopUSA
ON Shop
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Shop(idCountry, name, phone, location)
	SELECT inserted.idCountry, inserted.name, inserted.phone,
	       inserted.location
	FROM inserted
    INSERT INTO Scotland_db.dbo.Shop(idCountry, name, phone, location)
	SELECT inserted.idCountry, inserted.name, inserted.phone,
	       inserted.location
	FROM inserted
END