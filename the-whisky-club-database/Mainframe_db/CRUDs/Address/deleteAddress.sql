CREATE PROCEDURE deleteAddress @idAddress int
WITH ENCRYPTION
AS
BEGIN
    IF @idAddress IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idAddress) FROM Address WHERE idAddress = @idAddress
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    DECLARE @idCustomerCursor int, @idAddressCursor int
                    DECLARE customerCursor CURSOR FOR SELECT
                    idCustomer, idAddress FROM Customer
                    OPEN customerCursor
                    FETCH NEXT FROM customerCursor INTO @idCustomerCursor, @idAddressCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idAddressCursor = @idAddress
                            EXEC deleteCustomer @idCustomer = @idCustomerCursor
                        FETCH NEXT FROM customerCursor INTO @idCustomerCursor, @idAddressCursor
                    END
                    CLOSE customerCursor
                    DEALLOCATE customerCursor
                    UPDATE Address
                    SET status = 0
                    WHERE idAddress = @idAddress
                    PRINT('Address deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The address id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO