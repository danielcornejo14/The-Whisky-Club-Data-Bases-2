CREATE PROCEDURE insertSubscription @name varchar(64),
                                    @shoppingDiscount float, @shippingDiscount float
WITH ENCRYPTION
AS
BEGIN
    IF @name IS NOT NULL AND @shoppingDiscount IS NOT NULL
        AND @shippingDiscount IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(name) FROM Subscription WHERE name = @name) = 0
            AND @shoppingDiscount >= 0
            AND @shippingDiscount >= 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO Subscription(name, shoppingDiscount, shippingDiscount)
                    VALUES (@name, @shoppingDiscount, @shippingDiscount)
                    INSERT INTO UnitedStates_db.dbo.Subscription(name, shoppingDiscount, shippingDiscount)
                    VALUES (@name, @shoppingDiscount, @shippingDiscount)
                    INSERT INTO Scotland_db.dbo.Subscription(name, shoppingDiscount, shippingDiscount)
                    VALUES (@name, @shoppingDiscount, @shippingDiscount)
                    INSERT INTO Ireland_db.dbo.Subscription(name, shoppingDiscount, shippingDiscount)
                    VALUES (@name, @shoppingDiscount, @shippingDiscount)
                    COMMIT TRANSACTION
                    --Replication in the Employees_db.
                    DECLARE @shoppingString varchar(10)
                    SET @shoppingString = CAST(@shoppingDiscount as varchar(10))
                    DECLARE @shippingString varchar(10)
                    SET @shippingString = CAST(@shippingDiscount as varchar(10))
                    EXEC('CALL replicateInsertSubscription(''' + @name + '''' + ', ' + @shoppingString + ', ' + @shippingString + ')') AT MYSQL_SERVER
                    PRINT('Subscription inserted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The subscription name cannot be repeated, and the discounts must be 0 or greater.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO