CREATE PROCEDURE deleteCity @idCity int
WITH ENCRYPTION
AS
BEGIN
    IF @idCity IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCity) FROM City WHERE idCity = @idCity
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    DECLARE @idAddressForDelete int
                    SET @idAddressForDelete = (SELECT idAddress FROM Address WHERE idCity = @idCity)
                    EXEC deleteAddress @idAddress = @idAddressForDelete
                    UPDATE City
                    SET status = 0
                    WHERE idCity = @idCity
                    PRINT('City deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The city id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO