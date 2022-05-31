CREATE PROCEDURE updateState @idState int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idState IS NOT NULL AND @name IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idState) FROM State WHERE idState = @idState
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM State WHERE name = @name) = 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE State
                    SET name = @name
                    WHERE idState = @idState
                    PRINT('State updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The state name cannot be repeated and the state id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO