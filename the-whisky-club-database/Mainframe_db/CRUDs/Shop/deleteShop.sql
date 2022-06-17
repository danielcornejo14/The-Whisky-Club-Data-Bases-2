CREATE PROCEDURE deleteShop @pIdShop int
WITH ENCRYPTION
AS
BEGIN
    IF @pIdShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idShop) FROM Shop WHERE idShop = @pIdShop
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --------------------------
                    DECLARE @idCountry int
                    SET @idCountry = (SELECT(idCountry) FROM Shop WHERE idShop = @pIdShop)
                    IF @idCountry = 1 --1 is for USA.
                    BEGIN
                        --Delete Sale
                        EXEC [UnitedStates_db].[dbo].[deleteSaleByIdShop] @idShop = @pIdShop
                        --------------------------
                        --Delete whiskey x shop
                        UPDATE UnitedStates_db.dbo.WhiskeyXShop
                        SET status = 0
                        WHERE idShop = @pIdShop
                        --------------------------
                        --Delete shop in the USA db
                        UPDATE UnitedStates_db.dbo.Shop
                        SET status = 0
                        WHERE idShop = @pIdShop
                    END
                    ELSE IF @idCountry = 2 --2 is for Ireland
                    BEGIN
                        --Delete Sale
                        EXEC [Ireland_db].[dbo].[deleteSaleByIdShop] @idShop = @pIdShop
                        --------------------------
                        --Delete whiskey x shop
                        UPDATE Ireland_db.dbo.WhiskeyXShop
                        SET status = 0
                        WHERE idShop = @pIdShop
                        --------------------------
                        --Delete shop in the Ireland db
                        UPDATE Ireland_db.dbo.Shop
                        SET status = 0
                        WHERE idShop = @pIdShop
                    END
                    ELSE IF @idCountry = 3 --3 is for Scotland
                    BEGIN
                        --Delete Sale
                        EXEC [Scotland_db].[dbo].[deleteSaleByIdShop] @idShop = @pIdShop
                        --------------------------
                        --Delete whiskey x shop
                        UPDATE Scotland_db.dbo.WhiskeyXShop
                        SET status = 0
                        WHERE idShop = @pIdShop
                        --------------------------
                        --Delete shop in the Scotland db
                        UPDATE Scotland_db.dbo.Shop
                        SET status = 0
                        WHERE idShop = @pIdShop
                    END
                    --------------------------
                    --Delete shop in Mainframe
                    UPDATE Shop
                    SET status = 0
                    WHERE idShop = @pIdShop
                    --------------------------
                    --Delete country in employees db
                    DECLARE @pIdShopString varchar(5)
                    SET @pIdShopString = CAST(@pIdShop as varchar(5))
                    EXEC('CALL replicateDeleteShop(' + @pIdShopString + ')') AT MYSQL_SERVER
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
            RAISERROR('The Shop id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO