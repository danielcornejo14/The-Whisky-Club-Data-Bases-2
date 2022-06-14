DELIMITER //
CREATE PROCEDURE deleteEmployeeType (
     IN pIdEmployeeType int
)
BEGIN
    IF pIdEmployeeType IS NOT NULL
    THEN
        IF ((SELECT COUNT(idEmployeeType) FROM EmployeeType WHERE idEmployeeType = pIdEmployeeType
            AND status = 1) > 0)
        THEN
            START TRANSACTION;
            #Delete employee by id employee type
            UPDATE employee
            SET status = 0
            WHERE idEmployeeType = pIdEmployeeType;
            #Delete employee type
            UPDATE EmployeeType
            SET status = 0
            WHERE idEmployeeType = pIdEmployeeType;
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