CREATE TRIGGER trInsertWhiskeyReview
ON WhiskeyReview
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.WhiskeyReview(idCustomer, idWhiskey, comment, evaluation, date)
	SELECT inserted.idCustomer, inserted.idWhiskey, inserted.comment,
	       inserted.evaluation, inserted.date
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.WhiskeyReview(idCustomer, idWhiskey, comment, evaluation, date)
	SELECT inserted.idCustomer, inserted.idWhiskey, inserted.comment,
	       inserted.evaluation, inserted.date
	FROM inserted
    INSERT INTO Scotland_db.dbo.WhiskeyReview(idCustomer, idWhiskey, comment, evaluation, date)
	SELECT inserted.idCustomer, inserted.idWhiskey, inserted.comment,
	       inserted.evaluation, inserted.date
	FROM inserted
END