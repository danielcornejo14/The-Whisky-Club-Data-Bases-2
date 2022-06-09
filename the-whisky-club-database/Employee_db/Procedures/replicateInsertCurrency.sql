DELIMITER //
CREATE PROCEDURE replicateInsertCurrency (
     IN pName varchar(64)
)
BEGIN
    START TRANSACTION;
    INSERT INTO currency(name)
    VALUES(pName);
    SELECT 'Currency inserted.';
    COMMIT;
END //
DELIMITER ;