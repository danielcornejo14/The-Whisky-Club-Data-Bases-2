CREATE PROCEDURE updateWhiskeyType @idWhiskeyType int, @name varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyType IS NOT NULL AND @name IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM WhiskeyType WHERE name = @name) = 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyType
                    SET name = @name
                    WHERE idWhiskeyType = @idWhiskeyType
                    PRINT('WhiskeyType updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyType name cannot be repeated and the WhiskeyType id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO