CREATE PROCEDURE updateShopUSA @idCountry int, @name varchar(64),
                                    @phone varchar(8), @location geometry, @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idCountry IS NOT NULL AND @name IS NOT NULL AND @phone IS NOT NULL
        AND @location IS NOT NULL AND @idShop IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(name) FROM Shop WHERE name = @name) = 0
            AND (SELECT COUNT(idCountry) FROM Country WHERE idCountry = @idCountry
                AND status = 1) > 0
            AND (SELECT COUNT(location) FROM Shop WHERE (location.STEquals(@location) = 1)) = 0)
        BEGIN
            IF @phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
            BEGIN
                IF (SELECT COUNT(phone) FROM Shop WHERE phone = @phone) = 0
                BEGIN
                    BEGIN TRANSACTION
                        BEGIN TRY
                            UPDATE Shop
                            SET idCountry = @idCountry,
                                name = @name,
                                phone = @phone,
                                location = @location
                            WHERE idShop = @idShop
                            UPDATE Scotland_db.dbo.Shop
                            SET idCountry = @idCountry,
                                name = @name,
                                phone = @phone,
                                location = @location
                            WHERE idShop = @idShop
                            UPDATE Ireland_db.dbo.Shop
                            SET idCountry = @idCountry,
                                name = @name,
                                phone = @phone,
                                location = @location
                            WHERE idShop = @idShop
                            COMMIT TRANSACTION
                            --The updated shop is replicated in the Employees_db.
                            DECLARE @point varchar(64)
                            SET @point = @location.STAsText()
                            DECLARE @idCountryString varchar(5)
                            SET @idCountryString = CAST(@idCountry as varchar(5))
                            DECLARE @phoneString varchar(8)
                            SET @phoneString = CAST(@phone as varchar(8))
                            DECLARE @idShopString varchar(5)
                            SET @idShopString = CAST(@idShop as varchar(5))
                            EXEC('CALL replicateUpdateShop(' + @idShopString + ', ' + @idCountryString + ', ''' + @name + ''', ' + @phoneString + ', '''  + @point + ''')') AT MYSQL_SERVER
                            PRINT('Shop updated.')
                        END TRY
                        BEGIN CATCH
                            ROLLBACK TRANSACTION
                            RAISERROR('An error has occurred in the database.', 11, 1)
                        END CATCH
                END
                ELSE
                BEGIN
                    RAISERROR('The phone number cannot be repeated.', 11, 1)
                END
            END
            ELSE
            BEGIN
                RAISERROR('The phone number must be 8 digits.', 11, 1)
            END
        END
        ELSE
        BEGIN
            RAISERROR('The shop name and the location cannot be repeated, the id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO