DELIMITER //
CREATE PROCEDURE deleteEmployeeReviewByIdCustomer (
     IN pIdCustomer int
)
BEGIN
    IF pIdCustomer IS NOT NULL
    THEN
        IF ((SELECT COUNT(idCustomer) FROM employeereview WHERE idCustomer = pIdCustomer
            AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE employeereview
            SET status = 0
            WHERE idCustomer = pIdCustomer;
            SELECT 'Employee review updated.';
            COMMIT;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;