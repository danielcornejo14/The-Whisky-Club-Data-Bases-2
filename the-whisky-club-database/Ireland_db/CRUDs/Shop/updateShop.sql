CREATE PROCEDURE updateShop @idShop int, @idCountry int, @idAddress int, @name varchar(64),
                            @phone varchar(8), @location geometry
WITH ENCRYPTION
AS
BEGIN
    IF @idShop IS NOT NULL AND @idCountry IS NOT NULL AND @idAddress IS NOT NULL
        AND @name IS NOT NULL AND @phone IS NOT NULL
        AND @location IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(name) FROM Shop WHERE name = @name) = 0
            AND (SELECT COUNT(idCountry) FROM Country WHERE idCountry = @idCountry
                AND status = 1) > 0
            AND (SELECT COUNT(idAddress) FROM Address WHERE idAddress = @idAddress
                AND status = 1) > 0
            AND (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
                AND status = 1) > 0)
        BEGIN
            IF @phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
            BEGIN
                BEGIN TRANSACTION
                    BEGIN TRY
                        UPDATE Shop
                        SET idCountry = @idCountry,
                            idAddress = @idAddress,
                            name = @name,
                            phone = @phone,
                            location = @location
                        WHERE idShop = @idShop
                        PRINT('Shop updated.')
                        COMMIT TRANSACTION
                    END TRY
                    BEGIN CATCH
                        ROLLBACK TRANSACTION
                        RAISERROR('An error has occurred in the database.', 11, 1)
                    END CATCH
            END
            ELSE
            BEGIN
                RAISERROR('The phone number must be 8 digits.', 11, 1)
            END
        END
        ELSE
        BEGIN
            RAISERROR('The shop name cannot be repeated and the ids must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO