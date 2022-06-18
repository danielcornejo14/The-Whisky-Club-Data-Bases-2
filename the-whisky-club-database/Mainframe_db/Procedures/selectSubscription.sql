CREATE OR ALTER PROCEDURE selectSubscription
WITH ENCRYPTION
AS
BEGIN
    SELECT idSubscription, name, shippingDiscount, shoppingDiscount
    FROM Subscription
    WHERE status = 1
END