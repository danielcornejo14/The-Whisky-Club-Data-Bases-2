CREATE PROCEDURE deleteWhiskeyXShop @idWhiskeyXShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyXShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyXShop) FROM WhiskeyXShop WHERE idWhiskeyXShop = @idWhiskeyXShop
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyXShop
                    SET status = 0
                    WHERE idWhiskeyXShop = @idWhiskeyXShop
                    PRINT('WhiskeyXShop deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyXShop id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO