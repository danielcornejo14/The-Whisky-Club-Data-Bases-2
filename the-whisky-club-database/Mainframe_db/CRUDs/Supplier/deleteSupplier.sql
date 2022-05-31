CREATE PROCEDURE deleteSupplier @idSupplier int
WITH ENCRYPTION
AS
BEGIN
    IF @idSupplier IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idSupplier) FROM Supplier WHERE idSupplier = @idSupplier
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Whiskey
                    SET status = 0
                    WHERE idSupplier = @idSupplier
                    UPDATE Supplier
                    SET status = 0
                    WHERE idSupplier = @idSupplier
                    PRINT('Supplier deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Supplier id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO