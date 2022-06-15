DELIMITER //
CREATE PROCEDURE updateEmployee (
     IN pIdEmployee int,
     IN pIdDepartment int,
     IN pIdEmployeeType int,
     IN pName varchar(64),
     IN pLastName1 varchar(64),
     IN pLastName2 varchar(64),
     IN pLocalSalary decimal(15,4),
     IN pDollarSalary decimal(15,4)
)
BEGIN
    IF pIdDepartment IS NOT NULL AND pName IS NOT NULL
        AND pIdEmployeeType IS NOT NULL AND pLastName1 IS NOT NULL
        AND pLastName2 IS NOT NULL AND pLocalSalary IS NOT NULL
        AND pDollarSalary IS NOT NULL AND pIdEmployee IS NOT NULL
     THEN
        IF ((SELECT COUNT(idDepartment) FROM department WHERE idDepartment = pIdDepartment AND status = 1) > 0
            AND (SELECT COUNT(idEmployeeType) FROM employeetype WHERE idEmployeeType = pIdEmployeeType AND status = 1) > 0
            AND pLocalSalary > 0
            AND pDollarSalary > 0
            AND (SELECT COUNT(idEmployee) FROM employee WHERE idEmployee = pIdEmployee AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE employee
            SET idDepartment = pIdDepartment,
                idEmployeeType = pIdEmployeeType,
                name = pName,
                lastName1 = pLastName1,
                lastName2 = pLastName2,
                localSalary = pLocalSalary,
                dollarSalary = pDollarSalary
            WHERE idEmployee = pIdEmployee;
            SELECT 'Employee updated.';
            COMMIT;
        ELSE
            SELECT 'The ids must exist, the name and user name cannot be repeated, and both salary must be 0 or greater.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;