CREATE PROCEDURE insertWhiskeyXSale @idWhiskey int, @idSale int, @quantity int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskey IS NOT NULL AND @idSale IS NOT NULL
        AND @quantity IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
                AND status = 1) > 0
            AND (SELECT COUNT(idSale) FROM Sale WHERE idSale = @idSale
                AND status = 1) > 0
            AND @quantity > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO WhiskeyXSale(idSale, idWhiskey, quantity)
                    VALUES (@idSale, @idWhiskey, @quantity)
                    PRINT('WhiskeyXSale inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The ids must exist and the quantity must be greater than 0.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO