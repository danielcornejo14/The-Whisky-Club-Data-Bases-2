CREATE TRIGGER trUpdateSubscription
ON Subscription
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Subscription
    SET name = inserted.name,
        shoppingDiscount = inserted.shoppingDiscount,
        shippingDiscount = inserted.shippingDiscount,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Subscription.idSubscription = inserted.idSubscription
    UPDATE Scotland_db.dbo.Subscription
    SET name = inserted.name,
        shoppingDiscount = inserted.shoppingDiscount,
        shippingDiscount = inserted.shippingDiscount,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Subscription.idSubscription = inserted.idSubscription
    UPDATE Ireland_db.dbo.Subscription
    SET name = inserted.name,
        shoppingDiscount = inserted.shoppingDiscount,
        shippingDiscount = inserted.shippingDiscount,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Subscription.idSubscription = inserted.idSubscription
END