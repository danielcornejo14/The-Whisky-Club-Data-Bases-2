--this will consult on the existences of whiskeys with the given filters
CREATE OR ALTER PROCEDURE productCatalogReport @idWhiskeyType int, @countryId int, @customerLocation geometry, @brand varchar(64), @ascendingDescending varchar(30),
											@price money, @availability bit, @popularity int
WITH ENCRYPTION
AS
BEGIN
	--Gather all the whiskey sales and properties in a CTE
    WITH WhiskeyCatalogCTE (
		idWhiskeyXShop, idShop, idWhiskey, status, totalStock, averageEvaluation, distance
	)
	AS
	(
		SELECT
			idWhiskeyXShop,
			WxS.idShop,
			WxS.idWhiskey,
			WxS.status,
			SUM(currentStock),
			AVG(evaluation),
			@customerLocation.STDistance(S.location)
		FROM Ireland_db.dbo.WhiskeyXShop WxS
		INNER JOIN Ireland_db.dbo.Shop S ON S.idShop = WxS.idShop
		INNER JOIN WhiskeyReview WR ON WR.idWhiskey = WxS.idWhiskey
		WHERE 
			(@countryId IS NULL OR @countryId = 0 OR S.idCountry = @countryId)
		GROUP BY
			idWhiskeyXShop,
			WxS.idShop,
			WxS.idWhiskey,
			WxS.status,
			@customerLocation.STDistance(S.location)
		UNION
		SELECT
			idWhiskeyXShop,
			WxS.idShop,
			WxS.idWhiskey,
			WxS.status,
			SUM(currentStock),
			AVG(evaluation),
			@customerLocation.STDistance(S.location)
		FROM Scotland_db.dbo.WhiskeyXShop WxS
		INNER JOIN Scotland_db.dbo.Shop S ON S.idShop = WxS.idShop
		INNER JOIN WhiskeyReview WR ON WR.idWhiskey = WxS.idWhiskey
		WHERE 
			(@countryId IS NULL OR @countryId = 0 OR S.idCountry = @countryId)
		GROUP BY
			idWhiskeyXShop,
			WxS.idShop,
			WxS.idWhiskey,
			WxS.status,
			@customerLocation.STDistance(S.location)
		UNION
		SELECT
			idWhiskeyXShop,
			WxS.idShop,
			WxS.idWhiskey,
			WxS.status,
			SUM(currentStock),
			AVG(evaluation),
			@customerLocation.STDistance(S.location)
		FROM UnitedStates_db.dbo.WhiskeyXShop WxS
		INNER JOIN UnitedStates_db.dbo.Shop S ON S.idShop = WxS.idShop
		INNER JOIN WhiskeyReview WR ON WR.idWhiskey = WxS.idWhiskey
		WHERE 
			(@countryId IS NULL OR @countryId = 0 OR S.idCountry = @countryId)
		GROUP BY
			idWhiskeyXShop,
			WxS.idShop,
			WxS.idWhiskey,
			WxS.status,
			@customerLocation.STDistance(S.location)
	)
	--Select Query information
	SELECT
		W.idWhiskey,
		idWhiskeyType,
		W.status,
		totalStock = (SELECT ISNULL(SUM(totalStock), 0) FROM WhiskeyCatalogCTE WC WHERE WC.idWhiskey = W.idWhiskey),
		whiskeyEvaluation = (SELECT ISNULL(AVG(averageEvaluation), 0) FROM WhiskeyCatalogCTE WC WHERE WC.idWhiskey = W.idWhiskey),
		distance = (SELECT ISNULL(distance, 0) FROM WhiskeyCatalogCTE WC WHERE WC.idWhiskey = W.idWhiskey)
    FROM Whiskey W
	--Filter by whiskey type
	WHERE
		(@idWhiskeyType IS NULL OR @idWhiskeyType = idWhiskeyType) AND
		(@popularity IS NULL OR @popularity = 0) AND
		(@availability IS NULL OR @availability = 0 OR (SELECT ISNULL(SUM(totalStock), 0) FROM WhiskeyCatalogCTE) > 0) AND
		(@brand IS NULL OR @brand = 0 OR W.brand = @brand) AND
		(@price IS NULL OR @price = 0 OR W.price <= @price) AND
		(@popularity IS NULL OR (SELECT ISNULL(AVG(averageEvaluation), 0) FROM WhiskeyCatalogCTE) > @popularity)
	GROUP BY W.idWhiskey, idWhiskeyType, W.status
END;
GO

EXEC productCatalogReport NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL;