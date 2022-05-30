CREATE PROCEDURE insertCity @idCounty int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @name IS NOT NULL AND @idCounty IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(name) FROM City WHERE name = @name) = 0
            AND (SELECT COUNT(idCounty) FROM County WHERE idCounty = @idCounty
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO City(idCounty, name)
                    VALUES (@idCounty , @name)
                    PRINT('City inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The City name cannot be repeated and County id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO