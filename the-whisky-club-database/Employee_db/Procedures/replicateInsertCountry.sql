DELIMITER //
CREATE PROCEDURE replicateInsertCountry (
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    IF pIdCurrency IS NOT NULL AND pName IS NOT NULL
    THEN
        IF ((SELECT COUNT(idCurrency) FROM currency WHERE idCurrency = pIdCurrency AND status = 1) > 0
            AND (SELECT COUNT(name) FROM country WHERE name = pName) = 0)
        THEN
            START TRANSACTION;
            INSERT INTO country(idCurrency, name)
            VALUES(pIdCurrency, pName);
            SELECT 'Country inserted.';
            COMMIT;
        ELSE
            SELECT 'The id currency must exist, and the name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;