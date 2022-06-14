DELIMITER //
CREATE PROCEDURE replicateUpdateCountry (
     IN pIdCountry int,
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    IF pIdCurrency IS NOT NULL AND pName IS NOT NULL
        AND pIdCountry IS NOT NULL
    THEN
        IF ((SELECT COUNT(idCurrency) FROM currency WHERE idCurrency = pIdCurrency AND status = 1) > 0
            AND (SELECT COUNT(name) FROM country WHERE name = pName) = 0
            AND (SELECT COUNT(idCountry) FROM country WHERE idCountry = pIdCountry AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE country
            SET idCurrency = pIdCurrency,
                name = pName
            WHERE idCountry = pIdCountry;
            SELECT 'Country updated.';
            COMMIT;
        ELSE
            SELECT 'The ids must exist, and the name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;