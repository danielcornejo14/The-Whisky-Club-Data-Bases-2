--this will consult on the existences of whiskeys with the given filters
CREATE OR ALTER PROCEDURE selectProductCatalog @idWhiskeyType int, @countryId int, @beforeDate date, @afterDate date
WITH ENCRYPTION
AS
BEGIN
	--Gather all the whiskey sales and properties in a CTE
    WITH WhiskeyCatalogCTE (
		idWhiskeyXShop, idShop, idWhiskey, currentStock, totalUnitsSold, status	
	)
	AS
	(
		SELECT idWhiskeyXShop, WxS.idShop, WxS.idWhiskey, currentStock, SUM(quantity), WxS.status
		FROM Ireland_db.dbo.WhiskeyXShop WxS
		INNER JOIN Ireland_db.dbo.WhiskeyXCustomer WxC ON WxS.idWhiskey = WxC.idWhiskey
		INNER JOIN Ireland_db.dbo.Shop S ON S.idShop = WxC.idShop
		WHERE 
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
		UNION
		SELECT idWhiskeyXShop, WxS.idShop, WxS.idWhiskey, currentStock, SUM(quantity), WxS.status
		FROM Scotland_db.dbo.WhiskeyXShop WxS
		INNER JOIN Ireland_db.dbo.WhiskeyXCustomer WxC ON WxS.idWhiskey = WxC.idWhiskey
		INNER JOIN Ireland_db.dbo.Shop S ON S.idShop = WxC.idShop
		WHERE 
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
		UNION
		SELECT idWhiskeyXShop, WxS.idShop, WxS.idWhiskey, currentStock, SUM(quantity), WxS.status
		FROM UnitedStates_db.dbo.WhiskeyXShop WxS
		INNER JOIN Ireland_db.dbo.WhiskeyXCustomer WxC ON WxS.idWhiskey = WxC.idWhiskey
		INNER JOIN Ireland_db.dbo.Shop S ON S.idShop = WxC.idShop
		WHERE 
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
	)
	--Select Query information
	SELECT WC.idWhiskey, idWhiskeyType, WC.status
    FROM WhiskeyCatalogCTE WC
	INNER JOIN Whiskey W ON W.idWhiskey = WC.idWhiskey
	--Filter by whiskey type
	WHERE (@idWhiskeyType IS NULL OR @idWhiskeyType = idWhiskeyType);
END;