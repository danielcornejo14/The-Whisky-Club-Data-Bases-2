--this will consult on the customers with the given filters
CREATE OR ALTER PROCEDURE selectCustomers @subscriptionType int
WITH ENCRYPTION
AS
BEGIN
    SELECT idCustomer, , name, , status
    FROM Customer C
	INNER JOIN Subscription S on S.idSubscription = C.idSubscription
	WHERE (@subscriptionType IS NULL OR @subscriptionType = C.idSubscription);
END;