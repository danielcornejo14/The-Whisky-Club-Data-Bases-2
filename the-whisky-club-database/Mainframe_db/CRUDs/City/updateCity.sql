CREATE PROCEDURE updateCity @idCity int, @name varchar(64), @idCounty int
WITH ENCRYPTION
AS
BEGIN
    IF @idCity IS NOT NULL AND @name IS NOT NULL AND
       @idCounty IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idCity) FROM City WHERE idCity = @idCity
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM City WHERE name = @name) = 0
            AND (SELECT COUNT(idCounty) FROM County WHERE idCounty = @idCounty
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE City
                    SET idCounty = @idCounty,
                        name = @name
                    WHERE idCity = @idCity
                    PRINT('City updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The City name cannot be repeated and both ids must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO