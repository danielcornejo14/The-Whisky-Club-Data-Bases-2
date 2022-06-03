CREATE TRIGGER trUpdateWhiskey
ON Whiskey
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Whiskey
    SET idSupplier = inserted.idSupplier,
        idPresentation = inserted.idPresentation,
        idCurrency = inserted.idCurrency,
        idWhiskeyType = inserted.idWhiskeyType,
        brand = inserted.brand,
        price = inserted.price,
        alcoholContent = inserted.alcoholContent,
        productionDate = inserted.productionDate,
        dueDate = inserted.dueDate,
        availability = inserted.availability,
        millilitersQuantity = inserted.millilitersQuantity,
        whiskeyAging = inserted.whiskeyAging,
        special = inserted.special,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Whiskey.idWhiskey = inserted.idWhiskey
    UPDATE Scotland_db.dbo.Whiskey
    SET idSupplier = inserted.idSupplier,
        idPresentation = inserted.idPresentation,
        idCurrency = inserted.idCurrency,
        idWhiskeyType = inserted.idWhiskeyType,
        brand = inserted.brand,
        price = inserted.price,
        alcoholContent = inserted.alcoholContent,
        productionDate = inserted.productionDate,
        dueDate = inserted.dueDate,
        availability = inserted.availability,
        millilitersQuantity = inserted.millilitersQuantity,
        whiskeyAging = inserted.whiskeyAging,
        special = inserted.special,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Whiskey.idWhiskey = inserted.idWhiskey
    UPDATE Ireland_db.dbo.Whiskey
    SET idSupplier = inserted.idSupplier,
        idPresentation = inserted.idPresentation,
        idCurrency = inserted.idCurrency,
        idWhiskeyType = inserted.idWhiskeyType,
        brand = inserted.brand,
        price = inserted.price,
        alcoholContent = inserted.alcoholContent,
        productionDate = inserted.productionDate,
        dueDate = inserted.dueDate,
        availability = inserted.availability,
        millilitersQuantity = inserted.millilitersQuantity,
        whiskeyAging = inserted.whiskeyAging,
        special = inserted.special,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Whiskey.idWhiskey = inserted.idWhiskey
END