CREATE OR ALTER PROCEDURE insertWhiskeyXShop @idWhiskey int, @idShop int, @currentStock int, @availability int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskey IS NOT NULL AND @idShop IS NOT NULL
        AND @currentStock IS NOT NULL AND @availability IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
                AND status = 1) > 0
            AND (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
                AND status = 1) > 0
            AND @currentStock > 0
            AND (@availability = 0 OR @availability= 1))
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO WhiskeyXShop(idShop, idWhiskey, currentStock, availability)
                    VALUES (@idShop, @idWhiskey, @currentStock, @availability)
                    PRINT('WhiskeyXShop inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The ids must exist, the availability must be 0 or 1 and the current stock must be greater than 0.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO