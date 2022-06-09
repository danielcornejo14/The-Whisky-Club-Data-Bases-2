DELIMITER //
CREATE PROCEDURE replicateUpdateCurrency (
     IN pIdCurrency int,
     IN pName varchar(64)
)
BEGIN
    START TRANSACTION;
    UPDATE currency
    SET name = pName
    WHERE idCurrency = pIdCurrency;
    SELECT 'Currency updated.';
    COMMIT;
END //
DELIMITER ;