CREATE PROCEDURE readState @idState int
WITH ENCRYPTION
AS
BEGIN
    IF @idState IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idState) FROM State WHERE idState = @idState
            AND status = 1) > 0
        BEGIN
            SELECT idState, name, status
            FROM State
            WHERE idState = @idState
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