DELIMITER //
CREATE PROCEDURE replicateInsertCountry (
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    START TRANSACTION;
    INSERT INTO country(idCurrency, name)
    VALUES(pIdCurrency, pName);
    SELECT 'Country inserted.';
    COMMIT;
END //
DELIMITER ;