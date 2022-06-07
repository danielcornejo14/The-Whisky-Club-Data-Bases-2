--this will consult on the employees with the given filters
CREATE OR ALTER PROCEDURE selectEmployees @department int, @score int, @salary float
WITH ENCRYPTION
AS
BEGIN
	WITH EmployeeCTE ()
    SELECT idEmployee, name, , status
    FROM WhiskeyXShop WxS
	INNER JOIN Whiskey W ON W.idWhiskey = WxS.idWiskey
	WHERE (@idWhiskeyType IS NULL OR @idWhiskeyType = idWhiskeyType) AND
		  (@idShop IS NULL OR @idShop = WxS.idShop);
END;