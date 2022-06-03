CREATE PROCEDURE insertShop @idCountry int, @name varchar(64),
                            @phone varchar(8), @location geometry
WITH ENCRYPTION
AS
BEGIN
    IF @idCountry IS NOT NULL
        AND @name IS NOT NULL AND @phone IS NOT NULL
        AND @location IS NOT NULL
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
                            INSERT INTO Shop(idCountry, name, phone, location)
                            VALUES (@idCountry, @name, @phone, @location)
                            PRINT('Shop inserted.')
                            COMMIT TRANSACTION
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