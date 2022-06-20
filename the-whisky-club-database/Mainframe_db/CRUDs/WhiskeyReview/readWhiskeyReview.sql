CREATE OR ALTER PROCEDURE readWhiskeyReview @idWhiskey int
WITH ENCRYPTION
AS
BEGIN
    IF @idWhiskey IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idWhiskeyReview) FROM WhiskeyReview WHERE idWhiskeyReview = @idWhiskey AND
             status = 1) > 0
        BEGIN
            SELECT idWhiskeyReview, idCustomer, idWhiskey,
                   comment, evaluation, date, status
            FROM WhiskeyReview
            WHERE idWhiskey = @idWhiskey AND status = 1
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
