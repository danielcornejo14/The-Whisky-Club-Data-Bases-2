CREATE TRIGGER trUpdatePresentation
ON Presentation
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Presentation
    SET description = inserted.description,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Presentation.idPresentation = inserted.idPresentation
    UPDATE Scotland_db.dbo.Presentation
    SET description = inserted.description,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Presentation.idPresentation = inserted.idPresentation
    UPDATE Ireland_db.dbo.Presentation
    SET description = inserted.description,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Presentation.idPresentation = inserted.idPresentation
END