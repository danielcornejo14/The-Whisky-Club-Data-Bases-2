CREATE PROCEDURE insertShop @idCountry int, @name varchar(64),
                            @phone varchar(8), @location geometry
WITH ENCRYPTION
AS
BEGIN
    IF @idCountry IS NOT NULL AND @name IS NOT NULL
        AND @phone IS NOT NULL AND @location IS NOT NULL
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
                            --The shop is inserted in the mainframe.
                            INSERT INTO Shop(idCountry, name, phone, location)
                            VALUES (@idCountry, @name, @phone, @location)
                            -----------------------------------------------------
                            DECLARE @idShop int
                            SET @idShop = SCOPE_IDENTITY()
                            --The inserted shop is inserted in its respective country db (horizontal fragmentation).
                            IF @idCountry = 1 --1 is for USA.
                            BEGIN
                                INSERT INTO UnitedStates_db.dbo.Shop(idShop, idCountry, name, phone, location)
                                VALUES(@idShop, @idCountry, @name, @phone, @location)
                            END
                            ELSE IF @idCountry = 2 --2 is for Ireland
                            BEGIN
                                INSERT INTO Ireland_db.dbo.Shop(idShop, idCountry, name, phone, location)
                                VALUES(@idShop, @idCountry, @name, @phone, @location)
                            END
                            ELSE IF @idCountry = 3 --3 is for Scotland
                            BEGIN
                                INSERT INTO Scotland_db.dbo.Shop(idShop, idCountry, name, phone, location)
                                VALUES(@idShop, @idCountry, @name, @phone, @location)
                            END
                            -----------------------------------------------------
                            COMMIT TRANSACTION
                            --The inserted shop is replicated in the Employees_db.
                            DECLARE @point varchar(64)
                            SET @point = @location.STAsText()
                            DECLARE @idCountryString varchar(5)
                            SET @idCountryString = CAST(@idCountry as varchar(5))
                            DECLARE @phoneString varchar(8)
                            SET @phoneString = CAST(@phone as varchar(8))
                            EXEC('CALL replicateInsertShop(' + '100' + ', ''' + 'a' + ''', ' + '11111111' + ', '''  + 'POINT(1 1)' + ''')') AT MYSQL_SERVER
                            PRINT('Shop inserted.')
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
