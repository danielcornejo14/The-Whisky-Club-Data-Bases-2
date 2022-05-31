CREATE PROCEDURE updateWhiskeyReview @idCustomer int, @idWhiskey int,
                                     @comment varchar(max), @evaluation int,
                                     @idWhiskeyReview int
WITH ENCRYPTION
AS
BEGIN
    IF @idCustomer IS NOT NULL AND @idWhiskey IS NOT NULL
        AND @comment IS NOT NULL AND @evaluation IS NOT NULL
        AND @idWhiskeyReview IS NOT NULL
    BEGIN
        IF ((SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = @idCustomer
            AND status = 1) > 0
            AND (SELECT COUNT(idWhiskey) FROM Whiskey WHERE idWhiskey = @idWhiskey
            AND status = 1) > 0
            AND @evaluation BETWEEN 1 AND 5
            AND (SELECT COUNT(idWhiskeyReview) FROM WhiskeyReview WHERE idWhiskeyReview = @idWhiskeyReview
            AND status = 1) > 0)
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    UPDATE WhiskeyReview
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
            RAISERROR('The ids must exist, and the evaluation must be a number between 1 and 5.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO