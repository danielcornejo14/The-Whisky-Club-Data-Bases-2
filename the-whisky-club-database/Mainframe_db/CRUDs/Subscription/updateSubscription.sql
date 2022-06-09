CREATE PROCEDURE updateSubscription @idSubscription int, @name varchar(64),
                                    @shoppingDiscount float, @shippingDiscount float
WITH ENCRYPTION
AS
BEGIN
    IF @idSubscription IS NOT NULL AND @name IS NOT NULL
       AND @shoppingDiscount IS NOT NULL AND @shippingDiscount IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idSubscription) FROM Subscription WHERE idSubscription = @idSubscription
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM Subscription WHERE name = @name) = 0
            AND @shoppingDiscount >= 0
            AND @shippingDiscount >= 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Subscription
                    SET name = @name,
                        shoppingDiscount = @shoppingDiscount,
                        shippingDiscount = @shippingDiscount
                    WHERE idSubscription = @idSubscription
                    UPDATE UnitedStates_db.dbo.Subscription
                    SET name = @name,
                        shoppingDiscount = @shoppingDiscount,
                        shippingDiscount = @shippingDiscount
                    WHERE idSubscription = @idSubscription
                    UPDATE Ireland_db.dbo.Subscription
                    SET name = @name,
                        shoppingDiscount = @shoppingDiscount,
                        shippingDiscount = @shippingDiscount
                    WHERE idSubscription = @idSubscription
                    UPDATE Scotland_db.dbo.Subscription
                    SET name = @name,
                        shoppingDiscount = @shoppingDiscount,
                        shippingDiscount = @shippingDiscount
                    WHERE idSubscription = @idSubscription
                    COMMIT TRANSACTION
                    --Replication in the Employees_db.
                    DECLARE @idSubscriptionString varchar(10)
                    SET @idSubscriptionString = CAST(@idSubscription as varchar(10))
                    DECLARE @shoppingString varchar(10)
                    SET @shoppingString = CAST(@shoppingDiscount as varchar(10))
                    DECLARE @shippingString varchar(10)
                    SET @shippingString = CAST(@shippingDiscount as varchar(10))
                    EXEC('CALL replicateUpdateSubscription(' + @idSubscriptionString + ', ' + '''' + @name + '''' + ', ' + @shoppingString + ', ' + @shippingString + ')') AT MYSQL_SERVER
                    PRINT('Subscription inserted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The subscription name cannot be repeated, the discounts must be 0 or greater.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO