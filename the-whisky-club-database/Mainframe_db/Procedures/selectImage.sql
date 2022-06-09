CREATE OR ALTER PROCEDURE selectImage @idWhiskey int
WITH ENCRYPTION
AS
BEGIN

	IF((select count(idImage) from Image where idWhiskey = @idWhiskey) > 0)
	BEGIN
		SELECT idImage, idWhiskey, image FROM Image WHERE idWhiskey = @idWhiskey AND status = 1
	END

	ELSE
	BEGIN
		SELECT '01' AS CODE, 'The wiskey does not have images.' AS MESSAGE
	END

END
GO
