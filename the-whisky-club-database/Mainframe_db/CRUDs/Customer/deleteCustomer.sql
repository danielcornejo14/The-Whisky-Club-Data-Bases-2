CREATE PROCEDURE deleteCustomer @pIdCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @pIdCustomer IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @pIdCustomer
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete employee review in employees
                    DECLARE @idCustomerString varchar(5)
                    SET @idCustomerString = CAST(@pIdCustomer as varchar(5))
                    EXEC('CALL deleteEmployeeReviewByIdCustomer(' + @idCustomerString + ')') AT MYSQL_SERVER
                    -----------------------------
                    --Delete whiskey x customer in USA
                    EXEC [UnitedStates_db].[dbo].[deleteWhiskeyXCustomerByIdCustomer] @idCustomer = @pIdCustomer
                    ------------------------------
                    --Delete whiskey x customer in Ireland
                    EXEC [Ireland_db].[dbo].[deleteWhiskeyXCustomerByIdCustomer] @idCustomer = @pIdCustomer
                    ------------------------------
                    --Delete whiskey x customer in Scotland
                    EXEC [Scotland_db].[dbo].[deleteWhiskeyXCustomerByIdCustomer] @idCustomer = @pIdCustomer
                    ------------------------------
                    --Delete whiskey review in mainframe
                    UPDATE WhiskeyReview
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    ------------------------------
                    --Delete whiskey review replication in countries
                    UPDATE UnitedStates_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    UPDATE Ireland_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    UPDATE Scotland_db.dbo.WhiskeyReview
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    ------------------------------
                    --Delete customer in mainframe
                    UPDATE Customer
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    ------------------------------
                    --Delete customer replication in countries
                    UPDATE UnitedStates_db.dbo.Customer
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    UPDATE Ireland_db.dbo.Customer
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    UPDATE Scotland_db.dbo.Customer
                    SET status = 0
                    WHERE idCustomer = @pIdCustomer
                    ------------------------------
                    COMMIT TRANSACTION
                    --Delete customer in employees db
                    SET @idCustomerString = CAST(@pIdCustomer as varchar(5))
                    EXEC('CALL replicateDeleteCustomer(' + @idCustomerString + ')') AT MYSQL_SERVER
                    PRINT('Currency deleted.')
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Customer id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO