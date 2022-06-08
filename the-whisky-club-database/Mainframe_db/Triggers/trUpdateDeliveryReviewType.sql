CREATE TRIGGER trUpdateDeliveryReviewType
ON DeliveryReviewType
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.DeliveryReviewType
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.DeliveryReviewType.idDeliveryReviewType = inserted.idDeliveryReviewType
    UPDATE Scotland_db.dbo.DeliveryReviewType
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.DeliveryReviewType.idDeliveryReviewType = inserted.idDeliveryReviewType
    UPDATE Ireland_db.dbo.DeliveryReviewType
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.DeliveryReviewType.idDeliveryReviewType = inserted.idDeliveryReviewType
END