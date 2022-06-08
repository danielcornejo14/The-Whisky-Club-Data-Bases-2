CREATE TRIGGER trInsertDeliveryReviewType
ON DeliveryReviewType
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.DeliveryReviewType(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.DeliveryReviewType(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO Scotland_db.dbo.DeliveryReviewType(name)
	SELECT inserted.name
	FROM inserted
END