--this will consult on the existences of whiskeys with the given filters
CREATE OR ALTER PROCEDURE productCatalogSalesReport @idWhiskeyType int = NULL,
@countryId int = NULL,
@beforeDate date = NULL,
@afterDate date = NULL
WITH ENCRYPTION
AS
BEGIN
	--Gather all the whiskey sales and properties in a CTE
    WITH WhiskeyCatalogCTE (
		idWhiskeyXShop, idShop, idWhiskey, totalStock, totalSales, status	
	)
	AS
	(
		SELECT
			idWhiskeyXShop,
			WxSh.idShop,
			WxSh.idWhiskey,
			totalStock = ISNULL((SELECT ISNULL(SUM(WxSh.currentStock), 0) FROM Ireland_db.dbo.Shop S WHERE S.idShop = WxSh.idShop AND (@countryId IS NULL OR S.idCountry = @countryId)),0),
			totalSales = (
				SELECT ISNULL(SUM(quantity), 0)
				FROM Ireland_db.dbo.WhiskeyXSale WxSa
				INNER JOIN Ireland_db.dbo.Sale S ON S.idSale = WxSa.idSale
				WHERE
					WxSa.idWhiskey = WxSh.idWhiskey AND
					(@beforeDate IS NULL OR @beforeDate < S.date) AND
					(@afterDate IS NULL OR @afterDate > S.date)
			),
			WxSh.status
		FROM Ireland_db.dbo.WhiskeyXShop WxSh
		GROUP BY 
			WxSh.idWhiskey,
			idWhiskeyXShop,
			WxSh.idShop,
			WxSh.status
		UNION
		SELECT
			idWhiskeyXShop,
			WxSh.idShop,
			WxSh.idWhiskey,
			totalStock = ISNULL((SELECT ISNULL(SUM(WxSh.currentStock), 0) FROM Scotland_db.dbo.Shop S WHERE S.idShop = WxSh.idShop AND (@countryId IS NULL OR S.idCountry = @countryId)),0),
			totalSales = (
				SELECT ISNULL(SUM(quantity), 0)
				FROM Scotland_db.dbo.WhiskeyXSale WxSa
				INNER JOIN Scotland_db.dbo.Sale S ON S.idSale = WxSa.idSale
				WHERE
					WxSa.idWhiskey = WxSh.idWhiskey AND
					(@beforeDate IS NULL OR @beforeDate < S.date) AND
					(@afterDate IS NULL OR @afterDate > S.date)
			),
			WxSh.status
		FROM Scotland_db.dbo.WhiskeyXShop WxSh
		GROUP BY 
			WxSh.idWhiskey,
			idWhiskeyXShop,
			WxSh.idShop,
			WxSh.status
		UNION
		SELECT
			idWhiskeyXShop,
			WxSh.idShop,
			WxSh.idWhiskey,
			totalStock = ISNULL((SELECT SUM(WxSh.currentStock) FROM UnitedStates_db.dbo.Shop S WHERE S.idShop = WxSh.idShop AND (@countryId IS NULL OR S.idCountry = @countryId)), 0),
			totalSales = (
				SELECT ISNULL(SUM(quantity), 0)
				FROM UnitedStates_db.dbo.WhiskeyXSale WxSa
				INNER JOIN UnitedStates_db.dbo.Sale S ON S.idSale = WxSa.idSale
				WHERE
					WxSa.idWhiskey = WxSh.idWhiskey AND
					(@beforeDate IS NULL OR @beforeDate < S.date) AND
					(@afterDate IS NULL OR @afterDate > S.date)
			),
			WxSh.status
		FROM UnitedStates_db.dbo.WhiskeyXShop WxSh
		GROUP BY 
			WxSh.idWhiskey,
			idWhiskeyXShop,
			WxSh.idShop,
			WxSh.status
	)
	--Select Query information
	SELECT
		WC.idWhiskey,
		idWhiskeyType,
		idShop,
		WC.status,
		totalStock,
		totalSales
    FROM WhiskeyCatalogCTE WC
	INNER JOIN Whiskey W ON W.idWhiskey = WC.idWhiskey
	--Filter by whiskey type
	WHERE (@idWhiskeyType IS NULL OR @idWhiskeyType = idWhiskeyType)
	ORDER BY idWhiskey;
END;
GO

EXEC productCatalogSalesReport NULL, NULL, NULL, NULL;
EXEC productCatalogSalesReport 2, NULL, NULL, NULL;
EXEC productCatalogSalesReport NULL, 1, NULL, NULL;
EXEC productCatalogSalesReport NULL, 2, NULL, NULL;
EXEC productCatalogSalesReport NULL, 3, NULL, NULL;
EXEC productCatalogSalesReport NULL, NULL, '2022-06-18', NULL;
EXEC productCatalogSalesReport NULL, NULL, '2022-06-19', NULL;
EXEC productCatalogSalesReport NULL, NULL, NULL, '2022-06-20';
