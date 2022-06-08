DELIMITER //
CREATE PROCEDURE replicateInsertCurrency (
     IN pName varchar(64)
)
BEGIN
    IF pName IS NOT NULL
    THEN
        IF (SELECT COUNT(name) FROM currency WHERE name = pName) = 0
        THEN
            START TRANSACTION;
            INSERT INTO currency(name)
            VALUES(pName);
            SELECT 'Currency inserted.';
            COMMIT;
        ELSE
            SELECT 'The currency name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;