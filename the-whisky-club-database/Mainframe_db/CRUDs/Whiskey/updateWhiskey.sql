CREATE PROCEDURE updateWhiskey  @idSupplier int, @idPresentation int,
                                @idCurrency int, @idWhiskeyType int,
                                @brand varchar(64), @price money,
                                @alcoholContent float, @productionDate date,
                                @dueDate date, @availability bit,
                                @millilitersQuantity float, @whiskeyAging int,
                                @special bit, @idWhiskey int
WITH ENCRYPTION
AS
BEGIN
    IF @idSupplier IS NOT NULL AND @idPresentation IS NOT NULL
        AND @brand IS NOT NULL AND @price IS NOT NULL
        AND @alcoholContent IS NOT NULL AND @millilitersQuantity IS NOT NULL
        AND @productionDate IS NOT NULL AND @dueDate IS NOT NULL
        AND @availability IS NOT NULL AND @idCurrency IS NOT NULL
        AND @idWhiskeyType IS NOT NULL AND @whiskeyAging IS NOT NULL
        AND @special IS NOT NULL AND @idWhiskey IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idSupplier) FROM Supplier WHERE idSupplier = @idSupplier
            AND status = 1) > 0
            AND (SELECT COUNT(idPresentation) FROM Presentation WHERE idPresentation = @idPresentation
            AND status = 1) > 0
            AND (SELECT COUNT(idCurrency) FROM Currency WHERE idCurrency = @idCurrency
            AND status = 1) > 0
            AND (SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType
            AND status = 1) > 0
            AND (SELECT COUNT(brand) FROM Whiskey WHERE brand = @brand) = 0
            AND (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
            AND status = 1) > 0
            AND @price > 0
            AND @alcoholContent >= 0
            AND (@productionDate < @dueDate)
            AND @millilitersQuantity > 0
            AND @whiskeyAging >= 0
            )
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE Whiskey
                    SET idSupplier = @idSupplier,
                        idPresentation = @idPresentation,
                        idCurrency = @idCurrency,
                        idWhiskeyType = @idWhiskeyType,
                        brand = @brand,
                        price = @price,
                        alcoholContent = @alcoholContent,
                        productionDate = @productionDate,
                        dueDate = @dueDate,
                        availability = @availability,
                        millilitersQuantity = @millilitersQuantity,
                        whiskeyAging = @whiskeyAging,
                        special = @special
                    WHERE idWhiskey = @idWhiskey
                    PRINT('Whiskey updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The ids must exist, the brand name cannot be repeated,' +
                      ' the quantity arguments must be greater than 0 and the' +
                      ' due date must be before the production date.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO