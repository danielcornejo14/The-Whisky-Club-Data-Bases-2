CREATE PROCEDURE selectCurrency
WITH ENCRYPTION
AS
BEGIN
    SELECT idCurrency, name, status
    FROM Currency
END