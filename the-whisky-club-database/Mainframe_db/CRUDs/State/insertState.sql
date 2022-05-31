CREATE PROCEDURE insertState @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @name IS NOT NULL
    BEGIN
        IF (SELECT COUNT(name) FROM State WHERE name = @name) = 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO State(name)
                    VALUES (@name)
                    PRINT('State inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The state name cannot be repeated.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO