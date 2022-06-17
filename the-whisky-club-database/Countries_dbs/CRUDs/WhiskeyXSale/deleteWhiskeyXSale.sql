CREATE PROCEDURE deleteWhiskeyXSale @idWhiskeyXSale int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyXSale IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyXSale) FROM WhiskeyXSale WHERE idWhiskeyXSale = @idWhiskeyXSale
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyXSale
                    SET status = 0
                    WHERE idWhiskeyXSale = @idWhiskeyXSale
                    PRINT('WhiskeyXSale deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyXSale id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO