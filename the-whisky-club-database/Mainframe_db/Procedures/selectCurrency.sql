CREATE OR ALTER PROCEDURE selectCurrency
WITH ENCRYPTION
AS
BEGIN
    SELECT idCurrency, name, status
    FROM Currency WHERE status = 1 
END
