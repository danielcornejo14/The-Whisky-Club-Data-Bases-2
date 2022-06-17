CREATE PROCEDURE updateWhiskeyXSale @idWhiskey int, @idSale int, @quantity int,
                                    @idWhiskeyXSale int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskey IS NOT NULL AND @idSale IS NOT NULL
        AND @quantity IS NOT NULL AND @idWhiskeyXSale IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
                AND status = 1) > 0
            AND (SELECT COUNT(idSale) FROM Sale WHERE idSale = @idSale
                AND status = 1) > 0
            AND (SELECT COUNT(idWhiskeyXSale) FROM WhiskeyXSale WHERE idWhiskeyXSale = @idWhiskeyXSale
                AND status = 1) > 0
            AND @quantity > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyXSale
                    SET idSale = @idSale,
                        idWhiskey = @idWhiskey,
                        quantity = @quantity
                    WHERE idWhiskeyXSale = @idWhiskeyXSale
                    PRINT('WhiskeyXSale updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The ids must exist and the current stock must be greater than 0.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO