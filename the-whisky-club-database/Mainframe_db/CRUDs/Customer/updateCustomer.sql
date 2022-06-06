CREATE PROCEDURE updateCustomer @idSubscription int, @idAddress int,
                                @emailAddress int, @name varchar(64),
                                @lastName1 varchar(64), @lastName2 varchar(64),
                                @location geometry, @userName varchar(64),
                                @password varchar(64), @idCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @idSubscription IS NOT NULL AND @idAddress IS NOT NULL
        AND @emailAddress IS NOT NULL AND @name IS NOT NULL
        AND @lastName1 IS NOT NULL AND @lastName2 IS NOT NULL
        AND @location IS NOT NULL AND @userName IS NOT NULL
        AND @password IS NOT NULL AND @idCustomer IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(*) FROM Customer WHERE name = @name AND lastName1 = @lastName1
            AND lastName2 = @lastName2) = 0
            AND (SELECT COUNT(idSubscription) FROM Subscription WHERE idSubscription = @idSubscription
            AND status = 1) > 0
            AND (SELECT COUNT(userName) FROM Customer WHERE userName = @userName) = 0
            AND (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @idCustomer
            AND status = 1) > 0
            AND (SELECT COUNT(location) FROM Customer WHERE (location.STEquals(@location) = 1)) = 0)
        BEGIN
            IF @emailAddress LIKE '%_@__%.__%'
            BEGIN
                /*              Password requirements
                1. The minimum length is 8 and maximum length is 64.
                2. The password must have a special character.
                3. The password must have a capital letter.
                4. The password must have a number.
                */
                IF @password COLLATE Latin1_General_BIN LIKE '%[A-Z]%'
                    AND @password LIKE '%[~!@#$%^&*()_+-={}\[\]:"|\;,./<>?'']%' ESCAPE '\'
                    AND @password LIKE '%[0-9]%'
                    AND LEN(@password) BETWEEN 8 AND 64
                BEGIN
                    IF (SELECT COUNT(password) FROM Customer WHERE password = HASHBYTES('MD4', @password)) = 0
                    BEGIN
                        BEGIN TRANSACTION
                            BEGIN TRY
                                UPDATE Customer
                                SET idSubscription = @idSubscription,
                                    emailAddress = @emailAddress,
                                    name = @name,
                                    lastName1 = @lastName1,
                                    lastName2 = @lastName2,
                                    location = @location,
                                    userName = @userName,
                                    password = HASHBYTES('MD4', @password)
                                WHERE idCustomer = @idCustomer
                                PRINT('Customer updated.')
                                COMMIT TRANSACTION
                            END TRY
                            BEGIN CATCH
                                ROLLBACK TRANSACTION
                                RAISERROR('An error has occurred in the database.', 11, 1)
                            END CATCH
                    END
                    ELSE
                    BEGIN
                        RAISERROR('The password cannot be repeated. ', 11, 1)
                    END
                END
                ELSE
                BEGIN
                    SELECT '03' AS message --This is the code error when the password format is invalid.
                    RAISERROR('The password must have a special character, a capital letter, a number, and the minimum length is 8 and maximum length is 64.', 11, 1)
                END
            END
            ELSE
            BEGIN
                SELECT '02' AS message --This is the code error when the email format is invalid.
                RAISERROR('The email address is not valid. ', 11, 1)
            END
        END
        ELSE
        BEGIN
            RAISERROR('The customer name, the userName and the location can not be repeated, and the ids must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO