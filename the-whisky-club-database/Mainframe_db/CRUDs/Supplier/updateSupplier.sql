CREATE PROCEDURE updateSupplier @name varchar(64), @emailAddress varchar(64),
                                @idSupplier int
WITH ENCRYPTION
AS
BEGIN
    IF @name IS NOT NULL AND @emailAddress IS NOT NULL
        AND @idSupplier IS NOT NULL
    BEGIN
        IF @emailAddress LIKE '%_@__%.__%'
        BEGIN
            IF ((SELECT COUNT(emailAddress) FROM Customer WHERE emailAddress = @emailAddress) = 0
                AND (SELECT COUNT(name) FROM Supplier WHERE name = @name) = 0)
            BEGIN
                BEGIN TRANSACTION
                    BEGIN TRY
                        UPDATE Supplier
                        SET name = @name,
                            emailAddress = @emailAddress
                        WHERE idSupplier = @idSupplier
                        PRINT('Supplier updated.')
                        COMMIT TRANSACTION
                    END TRY
                    BEGIN CATCH
                        ROLLBACK TRANSACTION
                        RAISERROR('An error has occurred in the database.', 11, 1)
                    END CATCH
            END
            ELSE
            BEGIN
                RAISERROR('The email address and the supplier name cannot be repeated.', 11, 1)
            END
        END
        ELSE
        BEGIN
            RAISERROR('The email address is not valid.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO