CREATE PROCEDURE deleteWhiskeyType @idWhiskeyType int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyType IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyType) FROM WhiskeyType WHERE idWhiskeyType = @idWhiskeyType
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete whiskey cursor
                    DECLARE @idWhiskeyCursor int, @idWhiskeyTypeCursor int
                    DECLARE whiskeyCursor CURSOR FOR SELECT
                    idWhiskey, idWhiskeyType FROM Whiskey
                    OPEN whiskeyCursor
                    FETCH NEXT FROM whiskeyCursor INTO @idWhiskeyCursor, @idWhiskeyTypeCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idWhiskeyTypeCursor = @idWhiskeyType
                            EXEC deleteWhiskey @idWhiskey = @idWhiskeyCursor
                        FETCH NEXT FROM whiskeyCursor INTO @idWhiskeyCursor, @idWhiskeyTypeCursor
                    END
                    ------------------------
                    --Delete whiskey type in Mainframe
                    UPDATE WhiskeyType
                    SET status = 0
                    WHERE idWhiskeyType = @idWhiskeyType
                    ------------------------
                    --Delete whiskey type replication in countries
                    UPDATE UnitedStates_db.dbo.WhiskeyType
                    SET status = 0
                    WHERE idWhiskeyType = @idWhiskeyType
                    UPDATE Scotland_db.dbo.WhiskeyType
                    SET status = 0
                    WHERE idWhiskeyType = @idWhiskeyType
                    UPDATE Ireland_db.dbo.WhiskeyType
                    SET status = 0
                    WHERE idWhiskeyType = @idWhiskeyType
                    ------------------------
                    PRINT('WhiskeyType deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyType id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO