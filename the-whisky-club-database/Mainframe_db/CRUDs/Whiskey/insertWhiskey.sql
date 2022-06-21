CREATE OR ALTER PROCEDURE insertWhiskey @idSupplier int, @idPresentation int,
                                        @idWhiskeyType int,
                                        @brand varchar(64), @price money,
                                        @alcoholContent float, @productionDate date,
                                        @dueDate date,
                                        @millilitersQuantity float, @whiskeyAging int,
                                        @special bit, @quantity int
WITH ENCRYPTION
AS
BEGIN
    IF @idSupplier IS NOT NULL AND @idPresentation IS NOT NULL
        AND @brand IS NOT NULL AND @price IS NOT NULL
        AND @alcoholContent IS NOT NULL AND @millilitersQuantity IS NOT NULL
        AND @productionDate IS NOT NULL AND @dueDate IS NOT NULL
        AND @idWhiskeyType IS NOT NULL AND @whiskeyAging IS NOT NULL
        AND @special IS NOT NULL AND @quantity IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idSupplier) FROM Supplier WHERE idSupplier = @idSupplier
            AND status = 1) > 0
            AND (SELECT COUNT(idPresentation) FROM Presentation WHERE idPresentation = @idPresentation
            AND status = 1) > 0
            AND (SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType
            AND status = 1) > 0
            AND @price > 0
            AND @alcoholContent >= 0
            AND (@productionDate < @dueDate)
            AND @millilitersQuantity > 0
            AND @whiskeyAging >= 0
            AND @quantity >= 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO Whiskey(idSupplier, idPresentation,
                                        idWhiskeyType, brand, price, alcoholContent,
                                        productionDate, dueDate,
                                        millilitersQuantity, whiskeyAging, special)
                    VALUES (@idSupplier, @idPresentation,
                            @idWhiskeyType, @brand, @price , @alcoholContent,
                            @productionDate, @dueDate,
                            @millilitersQuantity, @whiskeyAging, @special)
                    DECLARE @idWhiskeyInserted int
                    SET @idWhiskeyInserted = SCOPE_IDENTITY()
                    INSERT INTO UnitedStates_db.dbo.Whiskey(idSupplier, idPresentation,
                                        idWhiskeyType, brand, price, alcoholContent,
                                        productionDate, dueDate,
                                        millilitersQuantity, whiskeyAging, special)
                    VALUES (@idSupplier, @idPresentation,
                            @idWhiskeyType, @brand, @price , @alcoholContent,
                            @productionDate, @dueDate,
                            @millilitersQuantity, @whiskeyAging, @special)
                    INSERT INTO UnitedStates_db.dbo.WhiskeyXShop(idShop, idWhiskey, currentStock, availability)
                    SELECT idShop, @idWhiskeyInserted, @quantity, 1
                    FROM UnitedStates_db.dbo.Shop
                    INSERT INTO Scotland_db.dbo.Whiskey(idSupplier, idPresentation,
                                        idWhiskeyType, brand, price, alcoholContent,
                                        productionDate, dueDate,
                                        millilitersQuantity, whiskeyAging, special)
                    VALUES (@idSupplier, @idPresentation,
                            @idWhiskeyType, @brand, @price , @alcoholContent,
                            @productionDate, @dueDate,
                            @millilitersQuantity, @whiskeyAging, @special)
                    INSERT INTO Scotland_db.dbo.WhiskeyXShop(idShop, idWhiskey, currentStock, availability)
                    SELECT idShop, @idWhiskeyInserted, @quantity, 1
                    FROM Scotland_db.dbo.Shop
                    INSERT INTO Ireland_db.dbo.Whiskey(idSupplier, idPresentation,
                                        idWhiskeyType, brand, price, alcoholContent,
                                        productionDate, dueDate,
                                        millilitersQuantity, whiskeyAging, special)
                    VALUES (@idSupplier, @idPresentation,
                            @idWhiskeyType, @brand, @price , @alcoholContent,
                            @productionDate, @dueDate,
                            @millilitersQuantity, @whiskeyAging, @special)
                    INSERT INTO Ireland_db.dbo.WhiskeyXShop(idShop, idWhiskey, currentStock, availability)
                    SELECT idShop, @idWhiskeyInserted, @quantity, 1
                    FROM Ireland_db.dbo.Shop
                    PRINT('Whiskey inserted.')
					SELECT '00' AS CODE, 'Whiskey inserted.' AS MESSAGE
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
					SELECT '01' AS CODE, 'An error has occurred in the database.' AS MESSAGE
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
			SELECT '02' AS CODE, 'The ids must exist, the brand name cannot be repeated, the quantity arguments must be greater than 0 and the due date must be before the production date.' AS MESSAGE
            RAISERROR('The ids must exist, every integer argument must be 0 or greater than 0 and the due date must be before the production date.', 11, 1)
        END
    END
    ELSE
    BEGIN
		SELECT '03' AS CODE, 'Null data is not allowed.' AS MESSAGE
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO

EXEC insertWhiskey @idSupplier = 2, @idPresentation = 1,
    @idWhiskeyType = 1, @brand = 'test', @price = 100, @alcoholContent = 0.5,
    @productionDate = N'2022-06-27', @dueDate = N'2022-10-27', @millilitersQuantity = 1200,
    @whiskeyAging = 18, @special = 1, @quantity = 100

select * from Whiskey