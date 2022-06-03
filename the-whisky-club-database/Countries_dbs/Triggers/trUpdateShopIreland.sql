CREATE TRIGGER trUpdateShopIreland
ON Shop
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE Scotland_db.dbo.Shop
    SET idCountry = inserted.idCountry,
        name = inserted.name,
        phone = inserted.phone,
        location = inserted.location,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Shop.idShop = inserted.idShop
    UPDATE UnitedStates_db.dbo.Shop
    SET idCountry = inserted.idCountry,
        name = inserted.name,
        phone = inserted.phone,
        location = inserted.location,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Shop.idShop = inserted.idShop\
    INSERT INTO mysql_server...Subscription(name, shoppingDiscount, shippingDiscount)
    SELECT inserted.name, inserted.shoppingDiscount, inserted.shippingDiscount
	FROM inserted
END