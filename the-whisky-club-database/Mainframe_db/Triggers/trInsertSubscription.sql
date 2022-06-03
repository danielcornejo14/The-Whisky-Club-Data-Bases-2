CREATE TRIGGER trInsertSubscription
ON Subscription
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Subscription(name, shoppingDiscount, shippingDiscount)
	SELECT inserted.name, inserted.shoppingDiscount, inserted.shippingDiscount
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.Subscription(name, shoppingDiscount, shippingDiscount)
	SELECT inserted.name, inserted.shoppingDiscount, inserted.shippingDiscount
	FROM inserted
    INSERT INTO Scotland_db.dbo.Subscription(name, shoppingDiscount, shippingDiscount)
	SELECT inserted.name, inserted.shoppingDiscount, inserted.shippingDiscount
	FROM inserted
END