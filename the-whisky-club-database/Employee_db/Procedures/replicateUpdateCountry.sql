DELIMITER //
CREATE PROCEDURE replicateUpdateCountry (
     IN pIdCountry int,
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    START TRANSACTION;
    UPDATE country
    SET idCurrency = pIdCurrency,
        name = pName
    WHERE idCountry = pIdCountry;
    SELECT 'Country updated.';
    COMMIT;
END //
DELIMITER ;