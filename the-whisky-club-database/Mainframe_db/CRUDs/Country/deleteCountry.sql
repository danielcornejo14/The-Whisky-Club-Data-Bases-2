CREATE PROCEDURE deleteCountry @idCountry int
WITH ENCRYPTION
AS
BEGIN
    IF @idCountry IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCountry) FROM Country WHERE idCountry = @idCountry
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete shop cursor
                    DECLARE @idShopCursor int, @idCountryCursor int
                    DECLARE shopCursor CURSOR FOR SELECT
                    idShop, idCountry FROM Shop
                    OPEN shopCursor
                    FETCH NEXT FROM shopCursor INTO @idShopCursor, @idCountryCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idCountryCursor = @idCountry
                            EXEC deleteShop @idShop = @idShopCursor
                        FETCH NEXT FROM shopCursor INTO @idShopCursor, @idCountryCursor
                    END
                    CLOSE shopCursor
                    DEALLOCATE shopCursor
                    ----------------------------
                    --Delete country in Mainframe
                    UPDATE Country
                    SET status = 0
                    WHERE idCountry = @idCountry
                    ----------------------------
                    --Delete country replication in Countries
                    UPDATE UnitedStates_db.dbo.Country
                    SET status = 0
                    WHERE idCountry = @idCountry
                    UPDATE Scotland_db.dbo.Country
                    SET status = 0
                    WHERE idCountry = @idCountry
                    UPDATE Ireland_db.dbo.Country
                    SET status = 0
                    WHERE idCountry = @idCountry
                    ---------------------------
                    COMMIT TRANSACTION
                    --Delete country in employees db
                    DECLARE @idCountryString varchar(5)
                    SET @idCountryString = CAST(@idCountry as varchar(5))
                    EXEC('CALL replicateDeleteCountry(' + @idCountryString + ')') AT MYSQL_SERVER
                    PRINT('Country deleted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The country id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO