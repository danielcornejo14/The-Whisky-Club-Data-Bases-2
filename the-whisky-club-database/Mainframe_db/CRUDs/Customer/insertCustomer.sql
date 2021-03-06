CREATE PROCEDURE insertCustomer @emailAddress varchar(64), @name varchar(64),
                                @lastName1 varchar(64), @lastName2 varchar(64),
                                @location geometry, @userName varchar(64),
                                @password varchar(64), @idSubscription int
WITH ENCRYPTION
AS
BEGIN
    IF @emailAddress IS NOT NULL AND @name IS NOT NULL
        AND @lastName1 IS NOT NULL AND @lastName2 IS NOT NULL
        AND @location IS NOT NULL AND @userName IS NOT NULL
        AND @password IS NOT NULL AND @idSubscription IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(userName) FROM Customer WHERE userName = @userName) = 0
            AND (SELECT COUNT(location) FROM Customer WHERE (location.STEquals(@location) = 1)) = 0
            AND (SELECT COUNT(*) FROM Customer WHERE name = @name AND lastName1 = @lastName1
                AND lastName2 = @lastName2) = 0
            AND (SELECT COUNT(@idSubscription) FROM Subscription WHERE idSubscription = @idSubscription) > 0)
        BEGIN
            IF @emailAddress LIKE '%_@__%.__%'
            BEGIN
                IF (SELECT COUNT(emailAddress) FROM Customer WHERE emailAddress = @emailAddress) = 0
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
                        DECLARE @passwordEncrypted binary(64);
                        SET @passwordEncrypted = HASHBYTES('SHA2_256', @password);
                        IF (SELECT COUNT(password) FROM Customer WHERE password = @passwordEncrypted) = 0
                        BEGIN
                            BEGIN TRANSACTION
                                BEGIN TRY
                                    -----------------------------------------------------------------
                                    --The customer is inserted in the Mainframe.
                                    INSERT INTO Customer(idSubscription, emailAddress,
                                                         name, lastName1, lastName2, location,
                                                         userName, password)
                                    VALUES (@idSubscription, @emailAddress,
                                            @name, @lastName1, @lastName2, @location,
                                            @userName, @passwordEncrypted)
                                    -----------------------------------------------------------------
                                    --The customer is inserted in the countries dbs.
                                    INSERT INTO UnitedStates_db.dbo.Customer(idSubscription,
                                                                             emailAddress, name,
                                                                             lastName1, lastName2,
                                                                             location, userName,
                                                                             password)
                                    VALUES (@idSubscription, @emailAddress,
                                            @name, @lastName1, @lastName2, @location,
                                            @userName, @passwordEncrypted)
                                    INSERT INTO Scotland_db.dbo.Customer(idSubscription,
                                                                         emailAddress, name,
                                                                         lastName1, lastName2,
                                                                         location, userName,
                                                                         password)
                                    VALUES (@idSubscription, @emailAddress,
                                            @name, @lastName1, @lastName2, @location,
                                            @userName, @passwordEncrypted)
                                    INSERT INTO Ireland_db.dbo.Customer(idSubscription,
                                                                         emailAddress, name,
                                                                         lastName1, lastName2,
                                                                         location, userName,
                                                                         password)
                                    VALUES (@idSubscription, @emailAddress,
                                            @name, @lastName1, @lastName2, @location,
                                            @userName, @passwordEncrypted)
                                    -----------------------------------------------------------------
                                    COMMIT TRANSACTION
                                    --Customer replication to Employees_db
                                    DECLARE @locationPoint varchar(64)
                                    SET @locationPoint = @location.STAsText()
                                    DECLARE @idSubscriptionString varchar(5)
                                    SET @idSubscriptionString = CAST(@idSubscription as varchar(5))
                                    EXEC('CALL replicateInsertCustomer(' +
                                        @idSubscriptionString + ', ''' +
                                        @emailAddress + ''', ' + '''' +
                                        @name + ''', ' + '''' + @lastName1 +
                                        ''', ' + '''' + @lastName2 + ''', ' +
                                        '''' + @locationPoint + '''' + ', ''' +
                                        @userName + '''' + ', ''' + @password + '''' + ')') AT MYSQL_SERVER
                                    --Vertical fragmentation with customer account
                                    INSERT INTO CustomerAccount(userName, password)
                                    VALUES(@userName, @passwordEncrypted)
                                    PRINT('Customer inserted.')
									SELECT '00' AS CODE, 'Customer inserted.' AS MESSAGE
                                END TRY
                                BEGIN CATCH
                                    ROLLBACK TRANSACTION
									SELECT '01' AS CODE, 'An error has occurred in the database.' AS MESSAGE
                                    RAISERROR('An error has occurred in the database.', 11, 1)
                                END CATCH
                        END
                        ELSE
                        BEGIN
							SELECT '02' AS CODE, 'The password can not be repeated. ' AS MESSAGE
                            RAISERROR('The password can not be repeated. ', 11, 1)
                        END
                    END
                    ELSE
                    BEGIN
                        SELECT '03' AS CODE, 'The password must have a special character,' +
                                             ' a capital letter, a number, and the minimum' +
                                             ' length is 8 and maximum length is 64.' AS MESSAGE --This is the code error when the password format is invalid.
                        RAISERROR('The password must have a special character, a capital letter, a number, and the minimum length is 8 and maximum length is 64.', 11, 1)
                    END
                END
                ELSE
                BEGIN
					SELECT '04' AS CODE, 'The email address can not be repeated.' AS MESSAGE 
                    RAISERROR('The email address can not be repeated.', 11, 1)
                END
            END
            ELSE
            BEGIN
                SELECT '05' AS CODE, 'The email address is not valid.' AS MESSAGE  --This is the code error when the email format is invalid.
                RAISERROR('The email address is not valid.', 11, 1)
            END
        END
        ELSE
        BEGIN
			SELECT '06' AS CODE, 'The customer userName, the location and the customer name cannot be repeated.' AS MESSAGE
            RAISERROR('The customer userName, the location and the customer name cannot be repeated and the id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
		SELECT '07' AS CODE, 'Null data is not allowed.' AS MESSAGE
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO