CREATE PROCEDURE deleteWhiskeyType @idWhiskeyType int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyType IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Whiskey
                    SET status = 0
                    WHERE idWhiskeyType = @idWhiskeyType
                    UPDATE WhiskeyType
                    SET status = 0
                    WHERE idWhiskeyType = @idWhiskeyType
                    PRINT('WhiskeyType deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyType id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO