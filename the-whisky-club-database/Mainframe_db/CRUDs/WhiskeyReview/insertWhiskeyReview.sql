CREATE PROCEDURE insertWhiskeyReview @idCustomer int, @idWhiskey int,
                                     @comment varchar(max), @evaluation int
WITH ENCRYPTION
AS
BEGIN
    IF @idCustomer IS NOT NULL AND @idWhiskey IS NOT NULL
        AND @comment IS NOT NULL AND @evaluation IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @idCustomer
            AND status = 1) > 0
            AND (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
            AND status = 1) > 0
            AND @evaluation BETWEEN 1 AND 5)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    INSERT INTO WhiskeyReview(idCustomer, idWhiskey, comment, evaluation, date)
                    VALUES (@idCustomer, @idWhiskey, @comment, @evaluation, GETDATE())
                    INSERT INTO UnitedStates_db.dbo.WhiskeyReview(idCustomer, idWhiskey, comment, evaluation, date)
                    VALUES (@idCustomer, @idWhiskey, @comment, @evaluation, GETDATE())
                    INSERT INTO Scotland_db.dbo.WhiskeyReview(idCustomer, idWhiskey, comment, evaluation, date)
                    VALUES (@idCustomer, @idWhiskey, @comment, @evaluation, GETDATE())
                    INSERT INTO Ireland_db.dbo.WhiskeyReview(idCustomer, idWhiskey, comment, evaluation, date)
                    VALUES (@idCustomer, @idWhiskey, @comment, @evaluation, GETDATE())
                    PRINT('WhiskeyReview inserted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The ids must exist, and the evaluation must be a number between 1 and 5.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO