CREATE TRIGGER trUpdateShopScotland
ON Shop
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Shop
    SET idCountry = inserted.idCountry,
        name = inserted.name,
        phone = inserted.phone,
        location = inserted.location,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Shop.idShop = inserted.idShop
    UPDATE Ireland_db.dbo.Shop
    SET idCountry = inserted.idCountry,
        name = inserted.name,
        phone = inserted.phone,
        location = inserted.location,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Shop.idShop = inserted.idShop
END