CREATE PROCEDURE readImage @idImage int
WITH ENCRYPTION
AS
BEGIN
    IF @idImage IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idImage) FROM Image WHERE idImage = @idImage
            AND status = 1) > 0
        BEGIN
            SELECT idImage, idWhiskey, image, status
            FROM Image
            WHERE idImage = @idImage
        END
        ELSE
        BEGIN
            RAISERROR('The Image id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO