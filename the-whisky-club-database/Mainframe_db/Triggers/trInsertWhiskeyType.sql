CREATE TRIGGER trInsertWhiskeyType
ON WhiskeyType
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.WhiskeyType(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.WhiskeyType(name)
	SELECT inserted.name
	FROM inserted
    INSERT INTO Scotland_db.dbo.WhiskeyType(name)
	SELECT inserted.name
	FROM inserted
END