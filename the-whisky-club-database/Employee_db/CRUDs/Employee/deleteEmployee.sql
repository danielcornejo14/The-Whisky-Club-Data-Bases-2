DELIMITER //
CREATE PROCEDURE deleteEmployee (
     IN pIdEmployee int
)
BEGIN
    IF pIdEmployee IS NOT NULL
    THEN
        IF ((SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = pIdEmployee
            AND status = 1) > 0)
        THEN
            START TRANSACTION;
            #Delete employee review
            UPDATE employeereview
            SET status = 0
            WHERE idEmployee = pIdEmployee;
            #Delete employee
            UPDATE Employee
            SET status = 0
            WHERE idEmployee = pIdEmployee;
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