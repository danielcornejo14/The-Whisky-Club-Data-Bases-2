DELIMITER //
CREATE PROCEDURE updateEmployeeType (
     IN pIdEmployeeType int,
     IN pName varchar(64)
)
BEGIN
    IF pIdEmployeeType IS NOT NULL AND pName IS NOT NULL
    THEN
        IF ((SELECT COUNT(idEmployeeType) FROM employeetype WHERE idEmployeeType = pIdEmployeeType
                AND status = 1) > 0
            AND (SELECT COUNT(name) FROM employeetype WHERE name = pName) = 0)
        THEN
            START TRANSACTION;
            UPDATE employeetype
            SET name = pName
            WHERE idEmployeeType = pIdEmployeeType;
            SELECT 'Employee type updated.';
            COMMIT;
        ELSE
            SELECT 'The ids must exist, the comment cannot be repeated and the evaluation must be a number between 1 and 5.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;