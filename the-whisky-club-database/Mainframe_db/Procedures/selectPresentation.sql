CREATE OR ALTER PROCEDURE selectPresentation
WITH ENCRYPTION
AS
BEGIN
    SELECT idPresentation, description, status
    FROM Presentation WHERE status = 1
END
