DELIMITER //
CREATE PROCEDURE replicateUpdateCurrency (
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    IF pidCurrency IS NOT NULL AND pName IS NOT NULL
    THEN
        IF ((SELECT COUNT(idCurrency) FROM currency WHERE idCurrency = pidCurrency AND status = 1) > 0
            AND (SELECT COUNT(name) FROM currency WHERE name = pName) = 0)
        THEN
            START TRANSACTION;
            UPDATE currency
            SET name = pName
            WHERE idCurrency = pIdCurrency;
            SELECT 'Currency updated.';
            COMMIT;
        ELSE
            SELECT 'The currency id must exist, and the name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;