CREATE OR ALTER PROCEDURE updateWhiskeyReview @userName varchar(64), @idWhiskey int,
                                             @comment varchar(max), @evaluation int,
                                             @idWhiskeyReview int
WITH ENCRYPTION
AS
BEGIN
    IF @userName IS NOT NULL AND @idWhiskey IS NOT NULL
        AND @comment IS NOT NULL AND @evaluation IS NOT NULL
        AND @idWhiskeyReview IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(userName) FROM Customer WHERE userName = @userName
            AND status = 1) > 0
            AND (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
            AND status = 1) > 0
            AND @evaluation BETWEEN 1 AND 5
            AND (SELECT COUNT(idWhiskeyReview) FROM WhiskeyReview WHERE idWhiskeyReview = @idWhiskeyReview
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    DECLARE @idCustomer int
                    SET @idCustomer = (SELECT (idCustomer) FROM Customer WHERE userName = @userName)
                    UPDATE WhiskeyReview
                    SET idCustomer = @idCustomer,
                        idWhiskey = @idWhiskey,
                        comment = @comment,
                        evaluation = @evaluation,
                        date = GETDATE()
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    UPDATE UnitedStates_db.dbo.WhiskeyReview
                    SET idCustomer = @idCustomer,
                        idWhiskey = @idWhiskey,
                        comment = @comment,
                        evaluation = @evaluation,
                        date = GETDATE()
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    UPDATE Scotland_db.dbo.WhiskeyReview
                    SET idCustomer = @idCustomer,
                        idWhiskey = @idWhiskey,
                        comment = @comment,
                        evaluation = @evaluation,
                        date = GETDATE()
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    UPDATE Ireland_db.dbo.WhiskeyReview
                    SET idCustomer = @idCustomer,
                        idWhiskey = @idWhiskey,
                        comment = @comment,
                        evaluation = @evaluation,
                        date = GETDATE()
                    WHERE idWhiskeyReview = @idWhiskeyReview
                    PRINT('WhiskeyReview updated.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The id and user name must exist, and the evaluation must be a number between 1 and 5.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO