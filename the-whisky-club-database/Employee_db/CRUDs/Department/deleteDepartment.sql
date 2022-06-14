DELIMITER //
CREATE PROCEDURE deleteDepartment (
     IN pIdDepartment int
)
BEGIN
    IF pIdDepartment IS NOT NULL
    THEN
        IF ((SELECT COUNT(idDepartment) FROM department WHERE idDepartment = pIdDepartment
            AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE employee
            INNER JOIN employeereview ON employeereview.idEmployee = employee.idEmployee
            SET employee.status = 0,
                employeereview.status = 0
            WHERE idDepartment = pIdDepartment;
            UPDATE department
            SET status = 0
            WHERE idDepartment = pIdDepartment;
            SELECT 'Department updated.';
            COMMIT;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;