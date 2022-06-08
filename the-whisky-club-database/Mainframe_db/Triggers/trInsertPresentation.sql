CREATE TRIGGER trInsertPresentation
ON Presentation
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Presentation(description)
	SELECT inserted.description
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.Presentation(description)
	SELECT inserted.description
	FROM inserted
    INSERT INTO Scotland_db.dbo.Presentation(description)
	SELECT inserted.description
	FROM inserted
END