CREATE PROCEDURE deleteSubscription @idSubscription int
WITH ENCRYPTION
AS
BEGIN
    IF @idSubscription IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idSubscription) FROM Subscription WHERE idSubscription = @idSubscription
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    DECLARE @idCustomerCursor int, @idSubscriptionCursor int
                    DECLARE customerCursor CURSOR FOR SELECT
                    idCustomer, idSubscription FROM Customer
                    OPEN customerCursor
                    FETCH NEXT FROM customerCursor INTO @idCustomerCursor, @idSubscriptionCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idSubscriptionCursor = @idSubscription
                            EXEC deleteCustomer @pIdCustomer = @idCustomerCursor
                        FETCH NEXT FROM customerCursor INTO @idCustomerCursor, @idSubscriptionCursor
                    END
                    CLOSE customerCursor
                    DEALLOCATE customerCursor
                    --Delete subscription in Mainframe
                    UPDATE Subscription
                    SET status = 0
                    WHERE idSubscription = @idSubscription
                    ---------------------------------
                    --Delete subscription replication in countries
                    UPDATE UnitedStates_db.dbo.Subscription
                    SET status = 0
                    WHERE idSubscription = @idSubscription
                    UPDATE Scotland_db.dbo.Subscription
                    SET status = 0
                    WHERE idSubscription = @idSubscription
                    UPDATE Ireland_db.dbo.Subscription
                    SET status = 0
                    WHERE idSubscription = @idSubscription
                    ---------------------------------
                    COMMIT TRANSACTION
                    --Delete Subscription in employees db
                    DECLARE @idSubscriptionString varchar(5)
                    SET @idSubscriptionString = CAST(@idSubscription as varchar(5))
                    EXEC('CALL replicateDeleteSubscription(' + @idSubscriptionString + ')') AT MYSQL_SERVER
                    PRINT('Subscription deleted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The subscription id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO