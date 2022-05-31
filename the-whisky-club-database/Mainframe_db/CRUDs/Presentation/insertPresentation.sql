CREATE PROCEDURE insertPresentation @description varchar(64)
WITH ENCRYPTION
AS
BEGIN
    IF @description IS NOT NULL
    BEGIN
        IF (SELECT COUNT(description) FROM Presentation WHERE description = @description) = 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO Presentation(description)
                    VALUES (@description)
                    PRINT('Presentation inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The presentation description cannot be repeated.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO