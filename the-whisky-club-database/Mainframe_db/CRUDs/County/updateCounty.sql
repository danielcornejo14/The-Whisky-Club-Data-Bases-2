CREATE PROCEDURE updateCounty @idCounty int, @name varchar(64), @idState int
WITH ENCRYPTION
AS
BEGIN
    IF @idCounty IS NOT NULL AND @name IS NOT NULL AND
       @idState IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idCounty) FROM County WHERE idCounty = @idCounty
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM County WHERE name = @name) = 0
            AND (SELECT COUNT(idState) FROM State WHERE idState = @idState
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE County
                    SET idState = @idState,
                        name = @name
                    WHERE idCounty = @idCounty
                    PRINT('County updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The County name cannot be repeated and both ids must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO