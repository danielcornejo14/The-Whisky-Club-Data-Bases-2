DELIMITER //
CREATE PROCEDURE replicateUpdateCurrency (
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    IF pName IS NOT NULL AND pIdCurrency IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM currency WHERE name = pName) = 0
            AND (SELECT COUNT(idCurrency) FROM currency WHERE idCurrency = pIdCurrency
                AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE currency
            SET name = pName
            WHERE idCurrency = pIdCurrency;
            SELECT 'Currency updated.';
            COMMIT;
        ELSE
            SELECT 'The currency name cannot be repeated, and the id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;