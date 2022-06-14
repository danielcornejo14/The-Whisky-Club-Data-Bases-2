CREATE PROCEDURE deleteWhiskeyXCustomerByIdCustomer @idCustomer int
WITH ENCRYPTION
AS
BEGIN
    IF @idCustomer IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCustomer) FROM WhiskeyXCustomer WHERE idCustomer = @idCustomer
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyXCustomer
                    SET status = 0
                    WHERE idCustomer = @idCustomer
                    PRINT('WhiskeyXCustomer deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The customer id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO