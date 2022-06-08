DELIMITER //
CREATE PROCEDURE replicateUpdateCountry (
     IN pIdCountry int,
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    IF pIdCountry IS NOT NULL AND pName IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM country WHERE name = pName) = 0
            AND (SELECT COUNT(idCountry) FROM Country WHERE idCountry = pIdCountry
                AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE country
            SET idCurrency = pIdCurrency,
                name = pName
            WHERE idCountry = pIdCountry;
            SELECT 'Country updated.';
            COMMIT;
        ELSE
            SELECT 'The country name cannot be repeated, the id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;