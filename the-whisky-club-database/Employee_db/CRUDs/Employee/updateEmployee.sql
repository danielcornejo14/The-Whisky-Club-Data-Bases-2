DELIMITER //
CREATE PROCEDURE updateEmployee (
     IN pIdEmployee int,
     IN pIdDepartment int,
     IN pIdEmployeeType int,
     IN pName varchar(64),
     IN pLastName1 varchar(64),
     IN pLastName2 varchar(64),
     IN pLocalSalary decimal(15,4),
     IN pDollarSalary decimal(15,4),
     IN pUserName varchar(64),
     IN pPassword varchar(64)
)
BEGIN
    IF pIdDepartment IS NOT NULL AND pName IS NOT NULL
        AND pIdEmployeeType IS NOT NULL AND pLastName1 IS NOT NULL
        AND pLastName2 IS NOT NULL AND pLocalSalary IS NOT NULL
        AND pDollarSalary IS NOT NULL AND pUserName IS NOT NULL
        AND pPassword IS NOT NULL AND pIdEmployee IS NOT NULL
     THEN
        IF ((SELECT COUNT(idDepartment) FROM department WHERE idDepartment = pIdDepartment AND status = 1) > 0
            AND (SELECT COUNT(idEmployeeType) FROM employeetype WHERE idEmployeeType = pIdEmployeeType AND status = 1) > 0
            AND (SELECT COUNT(name) FROM employee WHERE name = pName
                AND lastName1 = pLastName1 AND lastName2 = pLastName2) = 0
            AND pLocalSalary > 0
            AND pDollarSalary > 0
            AND (SELECT COUNT(userName) FROM employee WHERE userName = pUserName) = 0
            AND (SELECT COUNT(idEmployee) FROM employee WHERE idEmployee = pIdEmployee AND status = 1) > 0)
        THEN
            /*              Password requirements
            1. The minimum length is 8 and maximum length is 64.
            2. The password must have a special character.
            3. The password must have a capital letter.
            4. The password must have a number.
            */
            IF VALIDATE_PASSWORD_STRENGTH(pPassword) = 100
                AND LENGTH(pPassword) BETWEEN 8 AND 64
            THEN
                START TRANSACTION;
                UPDATE employee
                SET idDepartment = pIdDepartment,
                    idEmployeeType = pIdEmployeeType,
                    name = pName,
                    lastName1 = pLastName1,
                    lastName2 = pLastName2,
                    localSalary = pLocalSalary,
                    dollarSalary = pDollarSalary,
                    userName = pUserName,
                    password = pPassword
                WHERE idEmployee = pIdEmployee;
                SELECT 'Employee updated.';
                COMMIT;
            END IF;
        ELSE
            SELECT 'The ids must exist, the name and user name cannot be repeated, and both salary must be 0 or greater.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;