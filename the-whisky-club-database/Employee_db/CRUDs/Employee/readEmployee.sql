DELIMITER //
CREATE PROCEDURE readEmployee (
     IN pIdEmployee int
)
BEGIN
    IF pIdEmployee IS NOT NULL
    THEN
        IF (SELECT COUNT(idEmployee) FROM Employee WHERE idEmployee = pIdEmployee
            AND status = 1) > 0
        THEN
            SELECT idEmployee, idDepartment, idEmployeeType,
                   name, lastName1, lastName2, localSalary,
                   dollarSalary, userName, password, status
            FROM Employee;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;