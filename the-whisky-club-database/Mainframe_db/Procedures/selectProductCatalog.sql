--this will consult on the existences of whiskeys with the given filters
CREATE OR ALTER PROCEDURE selectProductCatalog @idWhiskeyType int, @shopId int
WITH ENCRYPTION
AS
BEGIN
    WITH WhiskeyExistencesCTE (idWhiskeyXShop, idShop, idWhiskey, currentStock, status)
	AS
	(
		SELECT * FROM Ireland_db.dbo.WhiskeyXShop
		UNION
		SELECT * FROM Scotland_db.dbo.WhiskeyXShop
		UNION
		SELECT * FROM UnitedStates_db.dbo.WhiskeyXShop
	)
	SELECT WE.idWhiskey, idWhiskeyType, WE.status
    FROM WhiskeyExistencesCTE WE
	INNER JOIN Whiskey W ON W.idWhiskey = WE.idWhiskey
	WHERE (@idWhiskeyType IS NULL OR @idWhiskeyType = idWhiskeyType) AND
		  (@shopId IS NULL OR @shopId = WE.idShop);
END;