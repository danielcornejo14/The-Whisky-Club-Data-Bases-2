CREATE PROCEDURE selectPresentation
WITH ENCRYPTION
AS
BEGIN
    SELECT idPresentation, description, status
    FROM Presentation
END