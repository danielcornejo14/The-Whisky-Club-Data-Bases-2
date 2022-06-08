--this will consult on the customers with the given filters
CREATE OR ALTER PROCEDURE selectCustomers @subscriptionType int, @beforeDate date, @afterDate date
WITH ENCRYPTION
AS
BEGIN
	WITH customerSalesCTE(idCustomer, total, shippingCost, date, idShop)
	AS
	(
		SELECT idCustomer, total, shippingCost, date, idShop FROM Ireland_db.dbo.WhiskeyXCustomer
		UNION
		SELECT idCustomer, total, shippingCost, date, idShop FROM Scotland_db.dbo.WhiskeyXCustomer
		UNION
		SELECT idCustomer, total, shippingCost, date, idShop FROM UnitedStates_db.dbo.WhiskeyXCustomer
	)
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
	WHERE (@subscriptionType IS NULL OR @subscriptionType = C.idSubscription);
END;