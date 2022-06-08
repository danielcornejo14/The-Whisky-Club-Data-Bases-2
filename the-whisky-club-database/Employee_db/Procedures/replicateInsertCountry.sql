DELIMITER //
CREATE PROCEDURE replicateInsertCountry (
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    IF pIdCurrency IS NOT NULL AND pName IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM country WHERE name = pName) = 0
            AND (SELECT COUNT(idCurrency) FROM currency WHERE idCurrency = pIdCurrency
                AND status = 1) > 0)
        THEN
            START TRANSACTION;
            INSERT INTO country(idCurrency, name)
            VALUES(pIdCurrency, pName);
            SELECT 'Country inserted.';
            COMMIT;
        ELSE
            SELECT 'The country name cannot be repeated, the id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;