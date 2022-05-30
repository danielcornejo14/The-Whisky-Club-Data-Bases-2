CREATE PROCEDURE readWhiskeyReview @idWhiskeyReview int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskeyReview IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyReview) FROM WhiskeyReview WHERE idWhiskeyReview = @idWhiskeyReview AND
             status = 1) > 0
        BEGIN
            SELECT idWhiskeyReview, idCustomer, idWhiskey,
                   comment, evaluation, date, status
            FROM WhiskeyReview
            WHERE idWhiskeyReview = @idWhiskeyReview
        END
        ELSE
        BEGIN
            RAISERROR('The WhiskeyReview id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO