CREATE PROCEDURE deleteCounty @idCounty int
WITH ENCRYPTION
AS
BEGIN
    IF @idCounty IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idCounty) FROM County WHERE idCounty = @idCounty
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    DECLARE @idCityCursor int, @idCountyCursor int
                    DECLARE countyCursor CURSOR FOR SELECT
                    idCity, idCounty FROM City
                    OPEN countyCursor
                    FETCH NEXT FROM countyCursor INTO @idCityCursor, @idCountyCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idCountyCursor = @idCounty
                            EXEC deleteCity @idCity = @idCityCursor
                        FETCH NEXT FROM countyCursor INTO @idCityCursor, @idCountyCursor
                    END
                    CLOSE countyCursor
                    DEALLOCATE countyCursor
                    UPDATE County
                    SET status = 0
                    WHERE idCounty = @idCounty
                    PRINT('County deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The County id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO