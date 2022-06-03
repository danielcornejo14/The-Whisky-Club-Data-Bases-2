CREATE PROCEDURE deleteShop @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --EXEC deleteDepartment
                    UPDATE WhiskeyXCustomer
                    SET status = 0
                    WHERE idShop = @idShop
                    UPDATE WhiskeyXShop
                    SET status = 0
                    WHERE idShop = @idShop
                    UPDATE Shop
                    SET status = 0
                    WHERE idShop = @idShop
                    PRINT('Shop deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Shop name cannot be repeated and the Shop id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO