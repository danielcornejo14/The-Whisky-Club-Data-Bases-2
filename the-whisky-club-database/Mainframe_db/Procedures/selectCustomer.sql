--this will consult on the customers with the given filters
CREATE OR ALTER PROCEDURE selectCustomers @subscriptionType int, @beforeDate date, @afterDate date, @countryId int
WITH ENCRYPTION
AS
BEGIN
	--Gather all the customer sales in a CTE
	WITH customerSalesCTE(idCustomer, total, shippingCost, date, idShop)
	AS
	(
		SELECT idCustomer, total, shippingCost, date, WxC.idShop
		FROM Ireland_db.dbo.WhiskeyXCustomer WxC
		INNER JOIN Ireland_db.dbo.Shop S on WxC.idShop = S.idShop
		WHERE
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
		UNION
		SELECT idCustomer, total, shippingCost, date, WxC.idShop
		FROM Scotland_db.dbo.WhiskeyXCustomer WxC
		INNER JOIN Scotland_db.dbo.Shop S on WxC.idShop = S.idShop
		WHERE
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
		UNION
		SELECT idCustomer, total, shippingCost, date, WxC.idShop
		FROM UnitedStates_db.dbo.WhiskeyXCustomer WxC
		INNER JOIN UnitedStates_db.dbo.Shop S on WxC.idShop = S.idShop
		WHERE
			(@countryId IS NULL OR S.idCountry = @countryId) AND
			(@beforeDate IS NULL OR @beforeDate < WxC.date) AND
			(@afterDate IS NULL OR WxC.date > @afterDate)
	)
	--Select the query information
    SELECT 
		C.idCustomer,
		C.name,
		C.status,
		S.name AS subscription,
		SUM(total) OVER(PARTITION BY C.idCustomer) AS salesTotal,
		SUM(shippingCost) OVER(PARTITION BY C.idCustomer) AS shippingCostTotal
    FROM Customer C
	INNER JOIN Subscription S on S.idSubscription = C.idSubscription
	INNER JOIN customerSalesCTE CS ON CS.idCustomer = C.idCustomer
	WHERE 
		--Verify the subscription type matches
		(@subscriptionType IS NULL OR @subscriptionType = C.idSubscription)
END;