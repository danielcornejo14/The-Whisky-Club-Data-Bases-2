CREATE OR ALTER PROCEDURE selectWhiskeyType
WITH ENCRYPTION
AS
BEGIN
    SELECT idWhiskeyType, name, status
    FROM WhiskeyType where status = 1
END
