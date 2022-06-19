--this will consult on the customers with the given filters
CREATE OR ALTER PROCEDURE customersReport @subscriptionType int, @beforeDate date, @afterDate date, @countryId int
WITH ENCRYPTION
AS
BEGIN
	--Gather all the customer sales in a CTE
	WITH customerSalesCTE(idCustomer, total, shippingCost, date, idShop)
	AS
	(
		SELECT idCustomer, SUM(total), SUM(shippingCost), date, WxC.idShop
		FROM Ireland_db.dbo.Sale WxC
		INNER JOIN Ireland_db.dbo.Shop S on WxC.idShop = S.idShop
		WHERE
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
		GROUP BY idCustomer, date, WxC.idShop
		UNION
		SELECT idCustomer, SUM(total), SUM(shippingCost), date, WxC.idShop
		FROM Scotland_db.dbo.Sale WxC
		INNER JOIN Scotland_db.dbo.Shop S on WxC.idShop = S.idShop
		WHERE
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
		GROUP BY idCustomer, date, WxC.idShop
		UNION
		SELECT idCustomer, SUM(total), SUM(shippingCost), date, WxC.idShop
		FROM UnitedStates_db.dbo.Sale WxC
		INNER JOIN UnitedStates_db.dbo.Shop S on WxC.idShop = S.idShop
		WHERE
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
		GROUP BY idCustomer, date, WxC.idShop
	)
	--Select the query information
    SELECT 
		C.idCustomer,
		C.name,
		C.status,
		S.name AS subscription,
		salesTotal = (
			SELECT ISNULL(SUM(total), 0) FROM customerSalesCTE CS WHERE CS.idCustomer = C.idCustomer
		),
		totalShippingCost = (
			SELECT ISNULL(SUM(shippingCost), 0) FROM customerSalesCTE CS WHERE CS.idCustomer = C.idCustomer
		)
    FROM Customer C
	INNER JOIN Subscription S on S.idSubscription = C.idSubscription
	WHERE 
		--Verify the subscription type matches
		(@subscriptionType IS NULL OR @subscriptionType = C.idSubscription)
END;
GO

exec customersReport null,null,null,null;
exec customersReport NULL,null,null, 1;
exec customersReport null,null,null, 2;