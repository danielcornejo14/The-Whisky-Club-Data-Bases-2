CREATE PROCEDURE deleteCustomer @idCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @idCustomer IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @idCustomer
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyReview
                    SET status = 0
                    WHERE idCustomer = @idCustomer
                    UPDATE Customer
                    SET status = 0
                    WHERE idCustomer = @idCustomer
                    PRINT('Customer deleted.')
                    COMMIT TRANSACTION
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