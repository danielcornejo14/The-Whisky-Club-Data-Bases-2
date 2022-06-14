DELIMITER //
CREATE PROCEDURE replicateDeleteCustomer (
     IN pIdCustomer int
)
BEGIN
    IF pIdCustomer IS NOT NULL
    THEN
        IF (SELECT COUNT(idCustomer) FROM Customer WHERE idCustomer = pIdCustomer AND status = 1) > 0
        THEN
            START TRANSACTION;
            UPDATE employeereview
            SET status = 0
            WHERE idCustomer = pIdCustomer;
            UPDATE customer
            SET status = 0
            WHERE idCustomer = pIdCustomer;
            COMMIT;
        ELSE
            SELECT 'The id customer must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;