CREATE PROCEDURE insertWhiskeyType @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @name IS NOT NULL
    BEGIN
        IF (SELECT COUNT(name) FROM WhiskeyType WHERE name = @name) = 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO WhiskeyType(name)
                    VALUES (@name)
                    INSERT INTO UnitedStates_db.dbo.WhiskeyType(name)
                    VALUES (@name)
                    INSERT INTO Ireland_db.dbo.WhiskeyType(name)
                    VALUES (@name)
                    INSERT INTO Scotland_db.dbo.WhiskeyType(name)
                    VALUES (@name)
                    PRINT('WhiskeyType inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyType name cannot be repeated.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO