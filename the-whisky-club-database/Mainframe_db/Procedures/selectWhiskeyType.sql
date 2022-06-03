CREATE PROCEDURE selectWhiskeyType
WITH ENCRYPTION
AS
BEGIN
    SELECT idWhiskeyType, name, status
    FROM WhiskeyType
END