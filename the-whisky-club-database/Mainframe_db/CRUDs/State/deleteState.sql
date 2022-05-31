CREATE PROCEDURE deleteState @idState int
WITH ENCRYPTION
AS
BEGIN
    IF @idState IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idState) FROM State WHERE idState = @idState
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    DECLARE @idCountyCursor int, @idStateCursor int
                    DECLARE countyCursor CURSOR FOR SELECT
                    idCounty, idState FROM County
                    OPEN countyCursor
                    FETCH NEXT FROM countyCursor INTO @idCountyCursor, @idStateCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idStateCursor = @idState
                            EXEC deleteCounty @idCounty = @idCountyCursor
                        FETCH NEXT FROM countyCursor INTO @idCountyCursor, @idStateCursor
                    END
                    CLOSE countyCursor
                    DEALLOCATE countyCursor
                    UPDATE State
                    SET status = 0
                    WHERE idState = @idState
                    PRINT('State deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The state id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO