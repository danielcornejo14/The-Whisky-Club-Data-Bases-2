CREATE TRIGGER trUpdateWhiskeyType
ON WhiskeyType
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.WhiskeyType
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.WhiskeyType.idWhiskeyType = inserted.idWhiskeyType
    UPDATE Scotland_db.dbo.WhiskeyType
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.WhiskeyType.idWhiskeyType = inserted.idWhiskeyType
    UPDATE Ireland_db.dbo.WhiskeyType
    SET name = inserted.name,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.WhiskeyType.idWhiskeyType = inserted.idWhiskeyType
END