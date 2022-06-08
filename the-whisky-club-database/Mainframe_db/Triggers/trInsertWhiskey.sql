CREATE TRIGGER trInsertWhiskey
ON Whiskey
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Whiskey(idSupplier, idPresentation, idCurrency,
	                                   idWhiskeyType, brand, price, alcoholContent,
	                                   productionDate, dueDate, availability, millilitersQuantity,
	                                   whiskeyAging, special)
	SELECT inserted.idSupplier, inserted.idPresentation, inserted.idCurrency,
	       inserted.idWhiskeyType, inserted.brand, inserted.price, inserted.alcoholContent,
	       inserted.productionDate, inserted.dueDate, inserted.availability,
	       inserted.millilitersQuantity, inserted.whiskeyAging,
	       inserted.special
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.Whiskey(idSupplier, idPresentation, idCurrency,
                                            idWhiskeyType, brand, price, alcoholContent,
                                            productionDate, dueDate, availability, millilitersQuantity,
                                            whiskeyAging, special)
	SELECT inserted.idSupplier, inserted.idPresentation, inserted.idCurrency,
	       inserted.idWhiskeyType, inserted.brand, inserted.price, inserted.alcoholContent,
	       inserted.productionDate, inserted.dueDate, inserted.availability,
	       inserted.millilitersQuantity, inserted.whiskeyAging,
	       inserted.special
	FROM inserted
    INSERT INTO Scotland_db.dbo.Whiskey(idSupplier, idPresentation, idCurrency,
	                                    idWhiskeyType, brand, price, alcoholContent,
	                                    productionDate, dueDate, availability, millilitersQuantity,
	                                    whiskeyAging, special)
	SELECT inserted.idSupplier, inserted.idPresentation, inserted.idCurrency,
	       inserted.idWhiskeyType, inserted.brand, inserted.price, inserted.alcoholContent,
	       inserted.productionDate, inserted.dueDate, inserted.availability,
	       inserted.millilitersQuantity, inserted.whiskeyAging,
	       inserted.special
	FROM inserted
END