CREATE PROCEDURE readPresentation @idPresentation int
WITH ENCRYPTION
AS
BEGIN
    IF @idPresentation IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPresentation) FROM Presentation WHERE idPresentation = @idPresentation
             AND status = 1) > 0
        BEGIN
            SELECT idPresentation, description, status
            FROM Presentation
            WHERE idPresentation = @idPresentation
        END
        ELSE
        BEGIN
            RAISERROR('The presentation id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO