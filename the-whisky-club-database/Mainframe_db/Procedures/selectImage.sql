CREATE OR ALTER PROCEDURE selectImage @idWhiskey int
WITH ENCRYPTION
AS
BEGIN

	IF((select count(idImage) from Image where idWhiskey = @idWhiskey) > 0)
	BEGIN
		SELECT idImage, idWhiskey, image, status FROM OPENJSON(
			(SELECT idImage, idWhiskey, image, status
			FROM Image
			FOR json auto)
		)WITH(idImage int, idWhiskey int, image varchar(max), status bit)WHERE idWhiskey = @idWhiskey AND status = 1 
	END

	ELSE
	BEGIN
		SELECT '01' AS CODE, 'The wiskey does not have images.' AS MESSAGE
	END

END
GO
