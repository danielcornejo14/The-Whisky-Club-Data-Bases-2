CREATE PROCEDURE updateAddress @idAddress int, @idCity int
WITH ENCRYPTION
AS
BEGIN
    IF @idAddress IS NOT NULL AND @idCity IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idAddress) FROM Address WHERE idAddress = @idAddress
            AND status = 1) > 0
            AND (SELECT COUNT(idCity) FROM City WHERE idCity = @idCity
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Address
                    SET idCity = @idCity
                    WHERE idAddress = @idAddress
                    PRINT('Address updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The address id and city id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO