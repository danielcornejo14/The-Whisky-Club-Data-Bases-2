CREATE PROCEDURE insertCounty @idState int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idState IS NOT NULL AND @name IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(name) FROM County WHERE name = @name) = 0
            AND (SELECT COUNT(idState) FROM State WHERE idState = @idState
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO County(idState, name)
                    VALUES (@idState , @name)
                    PRINT('County inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The county name cannot be repeated and the state id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO