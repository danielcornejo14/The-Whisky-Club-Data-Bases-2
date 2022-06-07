--this will consult on the existences of whiskeys with the given filters
CREATE OR ALTER PROCEDURE selectProductCatalog @subscriptionType int, @shopId int
WITH ENCRYPTION
AS
BEGIN
    WITH WhiskeyExistencesCTE (idWhiskeyXShop, idWhiskey, idShop)
	AS
	(
		SELECT * FROM Ireland_db.WhiskeyXShop
		UNION
		SELECT * FROM Scotland_db.WhiskeyXShop
		UNION
		SELECT * FROM UnitedStates_db.WhiskeyXShop
	)
	SELECT idWhiskey, idWhiskeyType, status
    FROM WhiskeyExistencesCTE WE
	INNER JOIN Whiskey W ON W.idWhiskey = WxS.idWiskey
	WHERE (@idWhiskeyType IS NULL OR @idWhiskeyType = idWhiskeyType) AND
		  (@idShop IS NULL OR @idShop = WE.idShop);
END;