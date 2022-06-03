CREATE TRIGGER trUpdateWhiskeyReview
ON WhiskeyReview
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.WhiskeyReview
    SET idCustomer = inserted.idCustomer,
        idWhiskey = inserted.idWhiskey,
        comment = inserted.comment,
	    evaluation = inserted.evaluation,
        date = inserted.date,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.WhiskeyReview.idWhiskeyReview = inserted.idWhiskeyReview
    UPDATE Scotland_db.dbo.WhiskeyReview
    SET idCustomer = inserted.idCustomer,
        idWhiskey = inserted.idWhiskey,
        comment = inserted.comment,
	    evaluation = inserted.evaluation,
        date = inserted.date,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.WhiskeyReview.idWhiskeyReview = inserted.idWhiskeyReview
    UPDATE Ireland_db.dbo.WhiskeyReview
    SET idCustomer = inserted.idCustomer,
        idWhiskey = inserted.idWhiskey,
        comment = inserted.comment,
	    evaluation = inserted.evaluation,
        date = inserted.date,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.WhiskeyReview.idWhiskeyReview = inserted.idWhiskeyReview
END